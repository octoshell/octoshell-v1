# coding: utf-8
FactoryGirl.define do
  factory :country do
    title_ru 'Россия'
  end

  factory :city do
    country
    title_ru 'Санкт-Петербург'
  end

  factory :membership do
    user
    organization
  end

  factory :credential do
    name 'my key'
    user
    public_key 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYgSu+9PML2L8D+eJI8zUwwnxvB42fRX7zRQINlnZDEUN2jZRb0LX9WAHjbm708T9EzFNj76atII6sHQkRn0j/SVQ4zmAyBijxmrrecJiTOD6SwFeySVF1DPgQGDvf7Jtp26CjfJ3SURapHFTpqZoD5VnqWXLpKLjpyTGeGUPnaLD8iNhL3pkn1GXubVllfTbZX7iGjQR3PZuD0mghATde/nzUHyXZcrbpBSvkBD9OzjVdoyy8cZPzqvtZw2QR6TnjYfXJct7cnLggyB4qOJjdTl9LejPOT2r5LIRsC+jL1jEcidb95sLvc+2wnceTNndbGOi0NBnkV+lrDU04I7JD releu@me.com'
  end

  factory :session do
    sequence(:description) { |n| "Session ##{n}" }
    sequence(:receiving_to) { |n| n.week.from_now }
  end

  factory :report do
    session
    project
  end

  factory :surety do
    boss_full_name 'Mr. Burns'
    boss_position 'CEO'
    project
    organization { project.organization }

    factory :generated_surety do
      after(:create) do |s|
        s.generate!
      end
    end

    factory :confirmed_surety do
      after(:create) do |s|
        s.generate!
        s.confirm!
      end
    end

    factory :active_surety do
      after(:create) do |s|
        s.generate!
        s.activate!
      end
    end

    factory :declined_surety do
      after(:create) do |s|
        s.generate!
        s.decline!
      end
    end

    factory :closed_surety do
      after(:create) do |s|
        s.close!
      end
    end
  end

  factory :surety_member do
    surety
    user

    factory :new_surety_member do
      user nil
      last_name 'Simpson'
      first_name 'Hank'
      middle_name '-'
      email 'eatmyshorts@example.com'
    end
  end

  factory :cluster do
    name 'Cluster'
    host '0.0.0.0'
  end

  factory :request do
    project
    cluster { factory(:cluster) }
    size 0
    gpu_hours 0
    cpu_hours 0

    factory :active_request do
      after(:create) { |r| r.activate! }
    end

    factory :declined_request do
      after(:create) { |r| r.decline! }
    end

    factory :closed_request do
      after(:create) { |r| r.close! }
    end

    factory :blocked_request do
      after(:create) do |r|
        r.activate!
        r.block!
      end
    end
  end

  factory :project_card, class: 'Project::Card' do
    name         'Проект'
    en_name      'Project'
    driver       'Драйвер'
    en_driver    'Driver'
    strategy     'Стратегия'
    en_strategy  'Strategy'
    objective    'Область'
    en_objective 'Objective'
    impact       'Импакт'
    en_impact    'Impact'
    usage        'Использование'
    en_usage     'Usage'
  end

  factory :organization_kind do
    name 'Kind'
  end

  factory :organization do
    organization_kind { factory(:organization_kind) }
    name 'Organization'
    country
    city
  end

  factory :project_prefix do
    name 'prefix-'
  end

  factory :direction_of_science do
    sequence(:name) { |n| "direction #{n}" }
  end

  factory :research_area do
    sequence(:name) { |n| "area #{n}" }
    group 'all'
  end

  factory :critical_technology do
    sequence(:name) { |n| "technology #{n}" }
  end

  factory :project do
    sequence(:title) { |n| %w(ACME Arkham )[n.pred] || "Project #{n}" }
    user
    organization { factory(:organization) }
    project_prefix { factory(:project_prefix) }
    cluster_user_type 'project'
    direction_of_sciences { [factory(:direction_of_science)] }
    research_areas        { [factory(:research_area)] }
    critical_technologies { [factory(:critical_technology)] }

    after(:build) do |project|
      FactoryGirl.build(:project_card, project: project)
    end

    factory :closing_project do
      after(:create) { |p| p.close! }
    end

    factory :closed_project do
      after(:create) do |p|
        p.close!
        p.erase!
      end
    end
  end

  factory :user do
    sequence(:first_name) do |n|
      name = %w(Homer Marge Bart Lisa Meggy Abraham)[n.pred] || "Name_#{n}"
    end
    last_name 'Simpson'
    middle_name '-'
    phone '12345'
    sequence(:email) { |n| "user_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    activation_state 'active'

    after(:create) do |u|
      u.update_attribute :activation_state, 'active'
      factory(:membership, user: u)
    end

    factory :sured_user do
      after(:create) do |u|
        s = create(:generated_surety)
        create(:surety_member, user: u, surety: s)
        s.activate!
      end
    end

    factory :closed_user do
      after(:create) { |u| u.close! }
    end
  end

  factory :account do
    project
    user

    before(:create) do |a|
      Account.where(project_id: a.project_id, user_id: a.user_id).delete_all
    end

    factory :allowed_account do
      after(:create) do |a|
        a.allow!
      end
    end
  end
end
