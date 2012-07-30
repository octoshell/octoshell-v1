FactoryGirl.define do
  factory :cluster_user do
    project
    cluster
    
    factory 'pending_cluster_user' do
      before(:create) do |cluster_user|
        cluster_user.skip_activation = true
      end
    end
    
    factory 'activing_cluster_user' do
    end
    
    factory 'active_cluster_user' do
      after(:create) do |cluster_user|
        cluster_user.tasks.last.force_success
        cluster_user.reload
      end
    end
    
    factory 'pausing_cluster_user' do
      after(:create) do |cluster_user|
        cluster_user.tasks.last.force_success
        cluster_user.reload
        cluster_user.pause!
      end
    end
    
    factory 'paused_cluster_user' do
      after(:create) do |cluster_user|
        cluster_user.tasks.last.force_success
        cluster_user.reload
        cluster_user.pause!
        cluster_user.tasks.last.force_success
        cluster_user.reload
      end
    end
    
    factory 'resuming_cluster_user' do
      after(:create) do |cluster_user|
        cluster_user.tasks.last.force_success
        cluster_user.reload
        cluster_user.pause!
        cluster_user.tasks.last.force_success
        cluster_user.reload
        cluster_user.resume!
      end
    end
    
    factory 'closing_cluster_user' do
      after(:create) do |cluster_user|
        cluster_user.tasks.last.force_success
        cluster_user.reload
        cluster_user.close!
      end
    end
    
    factory 'closed_cluster_user' do
      after(:create) do |cluster_user|
        cluster_user.tasks.last.force_success
        cluster_user.reload
        cluster_user.force_close!
      end
    end
  end
end
