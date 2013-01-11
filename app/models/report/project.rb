# coding: utf-8
require 'zip/zip'

class Report::Project < ActiveRecord::Base
  LOGINS_PARSER = (lambda do |string|
    string.to_s.split(',').find_all(&:present?).map { |l| l.downcase.strip }.uniq
  end)

  DIRECTIONS_OF_SCIENCE = [
    'Безопасность и противодействие терроризму',
    'Индустрия наносистем',
    'Информационно-телекоммуникационные системы',
    'Науки о жизни',
    'Перспективные виды вооружения, военной и специальной техники',
    'Рациональное природопользование',
    'Транспортные и космические системы',
    'Энергоэффективность, энергосбережение, ядерная энергетика'
  ]

  COMPUTING_SYSTEMS = [
    '"Ломоносов", узлы с процессорами Intel',
    '"Ломоносов", узлы с процессорами NVIDIA',
    '"Чебышев"'
  ]

  CRITICAL_TECHNOLOGIES = [
    'Базовые и критические военные и промышленные технологии для создания перспективных видов вооружения, военной и специальной техники',
    'Базовые технологии силовой электротехники',
    'Биокаталитические, биосинтетические и биосенсорные технологии',
    'Биомедицинские и ветеринарные технологии',
    'Геномные, протеомные и постгеномные технологии',
    'Клеточные технологии',
    'Компьютерное моделирование наноматериалов, наноустройств и нанотехнологий',
    'Нано-, био-, информационные, когнитивные технологии',
    'Технологии атомной энергетики, ядерного топливного цикла, безопасного обращения с радиоактивными отходами и отработавшим ядерным топливом',
    'Технологии биоинженерии',
    'Технологии диагностики наноматериалов и наноустройств',
    'Технологии доступа к широкополосным мультимедийным услугам',
    'Технологии информационных, управляющих, навигационных систем',
    'Технологии наноустройств и микросистемной техники',
    'Технологии новых и возобновляемых источников энергии, включая водородную энергетику',
    'Технологии получения и обработки конструкционных наноматериалов',
    'Технологии получения и обработки функциональных наноматериалов',
    'Технологии и программное обеспечение распределенных и высокопроизводительных вычислительных систем',
    'Технологии мониторинга и прогнозирования состояния окружающей среды, предотвращения и ликвидации ее загрязнения',
    'Технологии поиска, разведки, разработки месторождений полезных ископаемых и их добычи',
    'Технологии предупреждения и ликвидации чрезвычайных ситуаций природного и техногенного характера',
    'Технологии снижения потерь от социально значимых заболеваний',
    'Технологии создания высокоскоростных транспортных средств и интеллектуальных систем управления новыми видами транспорта',
    'Технологии создания ракетно-космической и транспортной техники нового поколения',
    'Технологии создания электронной компонентной базы и энергоэффективных световых устройств',
    'Технологии создания энергосберегающих систем транспортировки, распределения и использования энергии',
    'Технологии энергоэффективного производства и преобразования энергии на органическом топливе'
  ]

  AREAS = [
    'Математика',
    'Информатика',
    'Механика',
    'Ядерная физика',
    'Физика конденсированных сред',
    'Оптика, квантовая электроника',
    'Радиофизика, электроника, акустика',
    'Физика плазмы',
    'Теоретическая физика',
    'Астрономия',
    'Медицинская физика',
    'Органическая химия',
    'Неорганическая химия',
    'Высокомолекулярные соединения',
    'Физическая химия',
    'Динамика и структура атомно-молекулярных систем',
    'Фундаментальные проблемы формирования новых материалов',
    'Общая биология',
    'Физико-химическая биология',
    'Фундаментальная медицина и физиология',
    'Геология',
    'Геохимия',
    'Горные науки',
    'Геофизика',
    'Океанология',
    'Физика атмосферы',
    'География и гидрология суши',
    'Науки о человеке и обществе',
    'Элементная база вычислительной техники и коммуникационных систем',
    'Сетевые технологии',
    'Алгоритмическое и программное обеспечение',
    'Фундаментальные основы инфокоммуникационных технологий и вычислительных систем',
    'Машиноведение и инженерная механика',
    'Процессы тепломассообмена, свойства веществ и материалов',
    'Электрофизика, электротехника и электроэнергетика',
    'Энергетика',
    'Атомная энергетика',
    'Технические системы и процессы управления',
    'Другое'
  ]

  STRICT_SCHEDULE = [
    '"Ломоносов", узлы с процессорами Intel',
    '"Ломоносов", узлы с процессорами NVIDIA',
    '"Чебышёв"'
  ]
  
  has_attached_file :materials,
    content_type: ['application/zip', 'application/x-zip-compressed'],
    max_size: 50.megabytes

  with_options on: :update do |m|
    m.validates :directions_of_science, length: { minimum: 1, maximum: 2, message: 'Нужно выбрать хотя бы %{count}' }

    m.validate :materials_validator
    m.validates :ru_title, :ru_author, :ru_email, :ru_driver, :ru_strategy,
      :ru_objective, :ru_impact, :ru_usage, :en_title, :en_author, :en_email,
      :en_driver, :en_strategy, :en_objective, :en_impact, :en_usage,
      presence: true
    
    m.validates :critical_technologies, length: { minimum: 1, maximum: 3, message: 'Нужно выбрать хотя бы %{count}' }

    m.validates :areas, presence: true
    
    m.validates :computing_systems, length: { minimum: 1, message: 'Нужно выбрать хотя бы %{count}' }
    
    m.validate :logins_validator
    m.validates :all_logins, length: { minimum: 1, message: 'Хотя бы один логин должен быть указан' }
    m.validates :materials, attachment_presence: true

    m.validates :ru_title, :ru_author, :ru_driver, :ru_strategy,
      :ru_objective, :ru_impact, :ru_usage,
      format: { with: /\A[а-яё\s\d,]+\z/i, message: "Должно быть на русском" }
    m.validates :en_title, :en_author, :en_driver, :en_strategy,
      :en_objective, :en_impact, :en_usage,
      format: { with: /\A[a-z\s\d,]+\z/i, message: "Должно быть на английском" }

    m.validates :books_count, :vacs_count, :lectures_count,
      :international_conferences_count, :international_conferences_in_russia_count,
      :russian_conferences_count, :doctors_dissertations_count,
      :candidates_dissertations_count, :students_count, :graduates_count,
      :your_students_count, :rffi_grants_count, :ministry_of_education_grants_count,
      :rosnano_grants_count, :ministry_of_communications_grants_count,
      :ministry_of_defence_grants_count, :ran_grants_count, :other_russian_grants_count,
      :other_intenational_grants_count, :awards_count, :lomonosov_intel_hours,
      :lomonosov_nvidia_hours, :chebyshev_hours, :lomonosov_size, :chebyshev_size,
      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  end

  def materials_validator
    if materials? && materials.queued_for_write.any?
      path = materials.queued_for_write.first[1].path
      z = Zip::ZipFile.open(path)
      entries = z.entries.find_all { |e| !(e.to_s =~ /\/$/) }
      if entries.size < 2
        errors.add(:materials, :min_files_is_two)
      end
      unless entries.find { |e| e.to_s =~ /(jpg|jpeg|png|tiff|bmp)\z/i }
        errors.add(:materials, :no_image)
      end
      z.close
    end
  end

  def logins_validator
    { chebyshev_logins: chebyshev_parsed_logins,
      lomonosov_logins: lomonosov_parsed_logins }.each do |attribute, logins|

      logins.each do |login|
        unless ClusterUser.where(username: login).exists?
          errors.add(attribute, :not_found, login: login)
        end
      end
    end
  end

  %w(critical_technologies directions_of_science computing_systems strict_schedule).each do |attr|
    define_method "#{attr}=" do |values|
      self[attr] = values.find_all(&:present?)
    end
  end

  def chebyshev_parsed_logins
    LOGINS_PARSER.call chebyshev_logins
  end

  def lomonosov_parsed_logins
    LOGINS_PARSER.call lomonosov_logins
  end

  def all_logins
    (chebyshev_parsed_logins + lomonosov_parsed_logins).uniq
  end

  attr_accessible :ru_title, :ru_author, :ru_email, :ru_area, :ru_driver,
    :ru_strategy, :ru_objective, :ru_impact, :ru_usage, :en_title, :en_author,
    :en_email, :en_area, :en_driver, :en_strategy, :en_objective, :en_impact,
    :en_usage, :graduates_count, :your_students_count,
    :ministry_of_education_grants_count, :rosnano_grants_count,
    :ministry_of_defence_grants_count, :award_names, :lomonosov_intel_hours,
    :lomonosov_nvidia_hours, :chebyshev_hours, :lomonosov_size, :chebyshev_size,
    :wanna_speak, :request_comment, :directions_of_science,
    :critical_technologies, :areas, :computing_systems, :lomonosov_logins,
    :chebyshev_logins, :books_count, :vacs_count, :lectures_count,
    :international_conferences_count, :russian_conferences_count,
    :doctors_dissertations_count, :candidates_dissertations_count,
    :students_count, :rffi_grants_count, :ministry_of_communications_grants_count,
    :ran_grants_count, :other_russian_grants_count, :other_intenational_grants_count,
    :strict_schedule, :international_conferences_in_russia_count, :awards_count,
    :materials
  
  serialize :directions_of_science, Array
  serialize :critical_technologies, Array
  serialize :computing_systems, Array
end
