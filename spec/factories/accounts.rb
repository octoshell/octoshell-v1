FactoryGirl.define do
  factory :account do
    project
    association :user, factory: :sured_user
    factory :active_account do
      state 'active'
    end
  end
end
