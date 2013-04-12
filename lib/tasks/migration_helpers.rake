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
      
      Surety.order('id').each do |s|
        s.update_column :organization_id, s.project.organization_id
      end
      
      SuretyMember.where(first_name: nil).each do |sm|
        first, middle, last = sm.full_name.split(' ')
        sm.first_name = first || 'Имя'
        sm.middle_name = middle || '-'
        sm.last_name = last || 'Фамилия'
        sm.save or raise sm.errors.inspect
      end
      
      Credential.unscoped.where("state = 'active'").select('public_key'). 
        group('public_key').having('COUNT("credentials"."public_key") > 1').
        count.each do |key, _|
        
        credentials = Credential.where(public_key: key).to_a
        credentials.pop # save one
        credentials.each &:destroy
      end
      
      # subdivisions ?
    end
  end
  
  task :show_invalids => :environment do
    [User, Account, Project, Surety, SuretyMember, Credential, Request].each do |model|
      model.find_each do |record|
        if record.invalid?
          p record
          p record.errors
        end and fail
      end
    end
  end
  
  task :migrate_reports => :environment do
    class OldReportProject < ActiveRecord::Base
      serialize :critical_technologies
      serialize :directions_of_science
      serialize :areas
      def project
        Project.find(project_id)
      end
    end
    
    ActiveRecord::Base.transaction do
      OldReportProject.where("project_id is not null").each do |rp|
        project = rp.project
        card = project.create_card do |card|
          card.name         = rp.ru_title
          card.en_name      = rp.en_title
          card.driver       = rp.ru_driver
          card.en_driver    = rp.en_driver
          card.strategy     = rp.ru_strategy
          card.en_strategy  = rp.en_strategy
          card.objective    = rp.ru_objective
          card.en_objective = rp.en_objective
          card.impact       = rp.ru_impact
          card.en_impact    = rp.en_impact
          card.usage        = rp.ru_usage
          card.en_usage     = rp.en_usage
        end
        card.persisted? or raise card.errors.inspect
        project.critical_technologies = rp.critical_technologies.map { |n| CriticalTechnology.find_by_name!(n) }
        project.direction_of_sciences = rp.directions_of_science.map { |n| DirectionOfScience.find_or_create_by_name!(n) }
        project.research_areas = rp.areas.map { |n| ResearchArea.find_by_name!(n) }
        project.save or raise project.errors.inspect
      end
    end
  end
  
  task :disable_invalid_projects => :environment do
    ActiveRecord::Base.transaction do
      Project.all.each do |p|
        p.disable! if p.invalid?
      end
    end
  end
end
