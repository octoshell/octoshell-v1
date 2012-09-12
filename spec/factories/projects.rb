FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    association :user, factory: :sured_user 
    organization { user.memberships.first.organization }
    description 'Description'
  end
end
