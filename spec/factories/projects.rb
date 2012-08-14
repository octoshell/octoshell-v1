FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    association :user, factory: :sured_user 
    organization do
      user.memberships.first.organization
    end
    description 'Description'
    
    factory :model, class: 'Project' do
    end
    
    factory :active_project do
    end
    
    factory :closed_project do
      state 'closed'
    end
  end
end
