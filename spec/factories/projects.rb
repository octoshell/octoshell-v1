FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    project_prefix
    association :user, factory: :user_with_membership
    organization { user.memberships.first.organization }
    direction_of_sciences { [create(:direction_of_science)] }
    critical_technologies { [create(:critical_technology)] }
    description 'Description'
    
    factory :active_project do
      state 'active'
    end
  end
end
