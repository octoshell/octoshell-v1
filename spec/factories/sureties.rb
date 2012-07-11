FactoryGirl.define do
  factory :surety do
    user
    description 'Tratata'
    organization
    factory :confirmed_surety do
      state 'active'
    end
  end
end
