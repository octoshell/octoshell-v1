# coding: utf-8
FactoryGirl.define do
  factory :project_card, class: 'Project::Card' do
    project
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
  end
  
  factory :project_prefix do
    name 'prefix-'
  end
  
  factory :direction_of_science do
    name 'direction'
  end
  
  factory :research_area do
    name 'area'
    group 'all'
  end
  
  factory :critical_technology do
    name 'technology'
  end
  
  factory :project do
    user
    organization { factory(:organization) }
    project_prefix { factory(:project_prefix) }
    cluster_user_type 'project'
    direction_of_sciences { [factory(:direction_of_science)] }
    research_areas        { [factory(:research_area)] }
    critical_technologies { [factory(:critical_technology)] }
    
    factory :active_project do
      after(:create) { |p| p.activate! }
    end
    
    factory :blocked_project do
      after(:create) do |p|
        p.activate!
        p.block!
      end
    end
    
    factory :closing_project do
      after(:create) do |p|
        p.activate!
        p.block!
        p.close!
      end
    end
    
    factory :closed_project do
      after(:create) do |p|
        p.activate!
        p.close!
        p.erase!
      end
    end
  end
  
  factory :user do
    first_name 'Richard'
    middle_name '-'
    phone '12345'
    sequence(:last_name) { |n| "Nixon #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    activation_state 'active'
    
    factory :sured_user do
      after(:create) do |u|
        memberships { create(:membership, user: u) }
        s = create(:surety)
        create(:surety_member, user: u, surety: s)
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
    
    factory :active_account do
      association(:project, factory: :active_project)
      after(:create) do |a|
        a.allow!
      end
    end
  end
end
