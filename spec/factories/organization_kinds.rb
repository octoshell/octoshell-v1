FactoryGirl.define do
  factory :organization_kind do
    sequence(:name) { |n| "kind #{n}" }
    
    factory :closed_organization_kind do
      after(:create) do |organization_kind|
        organization_kind.close!
      end
    end
  end
end
