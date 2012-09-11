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
  end
end
