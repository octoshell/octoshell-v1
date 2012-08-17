FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "Organization #{n}" }
    organization_kind
    
    factory :closed_organization do
      after(:create) do |organization|
        organization.close!
      end
    end
  end
end
