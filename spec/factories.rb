# coding: utf-8
FactoryGirl.define do
  factory :credential do
    name 'my key'
    user
    public_key 'key---'
  end
  
  factory :surety do
    boss_full_name 'Mr. Burns'
    boss_position 'CEO'
    project
  end
  
  factory :surety_member do
    surety
    email { create(:user).email }
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
    first_name 'Richard'
    middle_name '-'
    phone '12345'
    sequence(:last_name) { |n| "Nixon #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    activation_state 'active'
    
    after(:create) do |u|
      u.update_attribute :activation_state, 'active'
    end
    
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
    
    factory :allowed_account do
      after(:create) do |a|
        a.allow!
      end
    end
  end
end
