FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
    organization_kind
  end
end
