FactoryGirl.define do
  factory :surety do
    user
    organization
    factory :confirmed_surety do
      state 'active'
    end
  end
end
