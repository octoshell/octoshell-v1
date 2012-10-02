FactoryGirl.define do
  factory :request do
    association :user, factory: :sured_user
    cluster_id { create(:cluster).id }
    project_id { create(:project, user: user).id }
    hours 1
    size 1
    
    factory :active_request do
      after(:create) do |request|
        request.activate!
        request.cluster_project.reload.complete_activation!
        request.cluster_project.cluster_users.activing.each &:complete_activation!
        request.cluster_project.cluster_users.active.map do |cu|
          cu.accesses.activing.each &:activate!
        end
      end
    end
    
    factory :closed_request do
      after(:create) do |request|
        request.close!
      end
    end
    
    factory :pending_request do
    end
  end
end
