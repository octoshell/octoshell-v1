FactoryGirl.define do
  factory :surety do
    user
    organization
    factory :active_surety do
      after(:create) do |surety|
        surety.activate!
      end
    end
  end
end
