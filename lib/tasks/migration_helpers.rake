# coding: utf-8
namespace :migration_helpers do
  task :all => :environment do
    AREAS = {
      'Математика, информатика, механика' => [
        'Математика',
        'Информатика',
        'Механика'
      ],
      'Физика и астрономия' => [
        'Ядерная физика',
        'Физика конденсированных сред',
        'Оптика, квантовая электроника',
        'Радиофизика, электроника, акустика',
        'Физика плазмы',
        'Теоретическая физика',
        'Астрономия',
        'Медицинская физика'
      ],
      'Химия' => [
        'Органическая химия',
        'Неорганическая химия',
        'Высокомолекулярные соединения',
        'Физическая химия',
        'Динамика и структура атомно-молекулярных систем',
        'Фундаментальные проблемы формирования новых материалов'  
      ],
      'Биология и медецинская наука' => [
        'Общая биология',
        'Физико-химическая биология',
        'Фундаментальная медицина и физиология'
      ],
      'Науки о земле' => [
        'Геология',
        'Геохимия',
        'Горные науки',
        'Геофизика',
        'Океанология',
        'Физика атмосферы',
        'География и гидрология суши'
      ],
      'Науки о человеке и обществе' => [
        'Науки о человеке и обществе'
      ],
      'Информационные технологии и вычислительные системы' => [
        'Элементная база вычислительной техники и коммуникационных систем',
        'Сетевые технологии',
        'Алгоритмическое и программное обеспечение',
        'Фундаментальные основы инфокоммуникационных технологий и вычислительных систем'
      ],
      'Фундаментальные основы инженерных наук' => [
        'Машиноведение и инженерная механика',
        'Процессы тепломассообмена, свойства веществ и материалов',
        'Электрофизика, электротехника и электроэнергетика',
        'Энергетика',
        'Атомная энергетика',
        'Технические системы и процессы управления'
      ],
      'Другое' => [
        'Другое'
      ]
    }
    
    ActiveRecord::Base.transaction do
      AREAS.each do |group, values|
        values.each do |value|
          ResearchArea.where(group: group, name: value).first_or_create!
        end
      end
      Surety.where(state: 'pending').update_all(state: 'generated')
      Surety.where(organization_id: nil).each do |s|
        s.update_column :organization_id, s.project.organization_id
      end
      Project.where(state: ['blocked', 'announced']).update_all(state: 'active')
      
      Account.update_all access_state: 'denied', cluster_state: 'closed'
      Account.where(state: 'active').update_all(access_state: 'allowed')
      Account.where(access_state: 'denied', cluster_state: 'closed').delete_all
      
      Request.where(project_id: nil).each do |r|
        r.project_id = ClusterProject.find(r.cluster_project_id).project_id
        r.cluster_id = ClusterProject.find(r.cluster_project_id).cluster_id
        r.save!
      end
    end
  end
  
  task :show_invalids => :environment do
    [User, Account, Project, Surety, SuretyMember, Credential].each do |model|
      model.find_each do |record|
        if record.invalid?
          p record
          p record.errors
        end and fail
      end
    end
  end
end
