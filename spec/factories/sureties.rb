FactoryGirl.define do
  factory :surety do
    user
    organization
    factory :active_surety do
      state 'active'
    end
  end
end
