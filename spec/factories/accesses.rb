FactoryGirl.define do
  factory :access do
    cluster_user
    credential
    
    before(:create) do |access|
      Access.where(
        cluster_user_id: access.cluster_user_id,
        credential_id: access.credential_id
      ).destroy_all
    end
    
    factory :active_access do |access|
      after(:create) do |access|
        access.activate!
        cluster_user.unmark_for_task!
        access.complete_activation!
      end
    end
  end
end
