FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    association :user, factory: :user_with_membership
    organization { user.memberships.first.organization }
    description 'Description'
  end
end
