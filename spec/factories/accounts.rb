FactoryGirl.define do
  factory :account do
    project
    association :user, factory: :sured_user
    
    before(:create) do |account|
      Account.where(
        project_id: account.project_id,
        user_id: account.user_id
      ).destroy_all
    end
    
    factory :active_account do |account|
      after(:create) do |account|
        account.activate!
      end
    end
  end
end
