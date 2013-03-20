FactoryGirl.define do
  factory :cluster_user do
    cluster_project
    account
    
    before(:create) do |cluster_user|
      ClusterUser.where(
        cluster_project_id: cluster_user.cluster_project_id,
        account_id: cluster_user.account_id
      ).destroy_all
    end
    
    factory :active_cluster_user do
      association :account, factory: :active_account
      
      after(:create) do |cluster_user|
        cluster_user.activate!
        cluster_user.unmark_for_task!
        cluster_user.complete_activation!
      end
    end
    
    factory :closing_cluster_user do
      association :account, factory: :active_account
      
      after(:create) do |cluster_user|
        cluster_user.activate!
        cluster_user.unmark_for_task!
        cluster_user.complete_activation!
        cluster_user.close!
        cluster_user.unmark_for_task!
      end
    end
  end
end
