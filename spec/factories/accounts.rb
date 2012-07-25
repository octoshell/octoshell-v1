FactoryGirl.define do
  factory :account do
    project
    user
    factory :active_account do
      state 'active'
    end
  end
end
