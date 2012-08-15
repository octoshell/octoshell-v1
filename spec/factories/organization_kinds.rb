FactoryGirl.define do
  factory :organization_kind do
    sequence(:name) { |n| "kind #{n}" }
  end
end
