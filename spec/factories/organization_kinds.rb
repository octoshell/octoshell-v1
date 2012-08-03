FactoryGirl.define do
  factory :organization_kind do
    sequence(:name) { |n| "kind #{n}" }
    sequence(:abbreviation) { |n| "abbr #{n}" }
  end
end
