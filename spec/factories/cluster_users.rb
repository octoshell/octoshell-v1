FactoryGirl.define do
  factory :cluster_user do
    account
    cluster_project
    factory 'pending_cluster_user' do
    end
    
    factory 'activing_cluster_user' do
      after :create do |cluster_user|
        cluster_user.activate!
      end
    end
    
    factory 'active_cluster_user' do
      after :create do |cluster_user|
        cluster_user.activate!
        cluster_user.tasks.perform_callbacks!
      end
    end
    
    factory 'closing_cluster_user' do
      after :create do |cluster_user|
        cluster_user.activate!
        cluster_user.tasks.first.perform_callbacks!
        cluster_user.reload.close!
      end
    end
    
    factory 'closed_cluster_user' do
      after :create do |cluster_user|
        cluster_user.activate!
        cluster_user.tasks.first.perform_callbacks!
        cluster_user.reload.close!
        cluster_user.tasks.first.perform_callbacks!
      end
    end
  end
end
