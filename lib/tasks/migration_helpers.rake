namespace :migration_helpers do
  task :all => :environment do
    msu = Organization.find(497)
    SUBDIVISION_CUTS = {
      'биологический факультет'                                  => 'био.фак-т',
      'научно-исследовательский вычислительный центр (НИВЦ)'     => 'НИВЦ',
      'научно-исследовательский институт ядерной физики (НИИЯФ)' => 'НИИЯФ',
      'химический факультет'                                     => 'хим.фак-т',
      'НИИ механики'                                             => 'НИИ Мех.',
      'геологический факультет'                                  => 'геол.фак-т',
      'экономический факультет'                                  => 'эко.фак-т',
      'физический факультет'                                     => 'физ.фак-т',
      'факультет вычислительной математики и кибернетики'        => 'ВМиК',
      'географический факультет'                                 => 'геогр.фак-т',
      'институт физико-химической биологии имени А.Н. Белозерского (НИИФХБ)' => 'НИИФХБ',
      'механико-математический факультет'                        => 'мех-мат.фак-т',
      'государственный астрономический институт (ГАИШ)'          => 'ГАИШ',
      'физико-химический факультет'                              => 'физ-хим.фак-т',
      'международный лазерный центр'                             => 'лазерный центр',
      'факультет фундаментальной медицины'                       => 'мед.фак-т',
      'институт теоретических проблем микромира'                 => 'ИТПМ',
      'кафедра физической культуры'                              => 'физк.каф.',
      'факультет наук о материалах'                              => 'фак-т наук о материалах',
      'факультет биоинженерии и биоинформатики'                  => 'фак-т биоинж. и биоинф.'
    }
    ActiveRecord::Base.transaction do
      OldReportOrganization.where(organization_id: 497).pluck(:subdivision).uniq.each do |s|
        next if s.blank?
        sub = msu.subdivisions.find_or_create_by_name(s)
        sub.persisted? || raise(sub.errors.inspect)
      end
      
      OldReportOrganization.where("organization_id is not null").each do |org|
        if report = OldReport.find_by_id(org.report_id)
          next if org.subdivision.blank?
          user = User.find(report.user_id)
          organization = Organization.find(org.organization_id)
          mem = user.memberships.where(organization_id: organization.id).first_or_initialize
          mem.subdivision = organization.subdivisions.where(name: org.subdivision).first_or_create!
          mem.save || raise(mem.errors.inspect)
        end
      end
      
      SUBDIVISION_CUTS.each do |name, short|
        if s = Subdivision.where(name: name).first
          s.short = short
          s.save!
        end
      end
    end
  end
end
