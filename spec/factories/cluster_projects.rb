FactoryGirl.define do
  factory :cluster_project do
    request
    
    factory 'activing_cluster_project' do
      after :create do |cluster_project|
        cluster_project.activate!
      end
    end
    
    factory 'active_cluster_project' do
      after :create do |cluster_project|
        cluster_project.activate!
        cluster_project.tasks.perform_callbacks!
      end
    end
    
    factory 'closing_cluster_project' do
      after :create do |cluster_project|
        cluster_project.activate!
        cluster_project.tasks.first.perform_callbacks!
        cluster_project.reload.close!
      end
    end
    
    factory 'closed_cluster_project' do
      after :create do |cluster_project|
        cluster_project.activate!
        cluster_project.tasks.first.perform_callbacks!
        cluster_project.reload.close!
        cluster_project.tasks.first.perform_callbacks!
      end
    end
  end
end
