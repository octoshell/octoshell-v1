FactoryGirl.define do
  factory :cluster_project do
    project
    cluster
    
    before(:create) do |cluster_project|
      ClusterProject.where(
        project_id: cluster_project.project_id,
        cluster_id: cluster_project.cluster_id
      ).destroy_all
    end
  end
end
