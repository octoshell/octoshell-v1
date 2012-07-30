FactoryGirl.define do
  factory :cluster_user do
    project
    cluster
    
    factory 'pending_cluster_user' do
      state 'pending'
    end
    
    factory 'activing_cluster_user' do
      state 'activing'
    end
    
    factory 'active_cluster_user' do
      state 'active'
    end
    
    factory 'pausing_cluster_user' do
      state 'pausing'
    end
    
    factory 'paused_cluster_user' do
      state 'paused'
    end
    
    factory 'resuming_cluster_user' do
      state 'resuming'
    end
    
    factory 'closing_cluster_user' do
      state 'closing'
    end
    
    factory 'closed_cluster_user' do
      state 'closed'
    end
  end
end
