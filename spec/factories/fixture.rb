class Fixture
  MODELS = [:user, :project, :cluster, :credential, :cluster_project,
    :account, :access, :cluster_user]
  
  attr_reader *MODELS
  
  def initialize
    @user = FactoryGirl.create(:sured_user)
    @project = FactoryGirl.create(:project)
    @cluster = FactoryGirl.create(:cluster)
    @credential = FactoryGirl.create(:credential, user: @user)
    @cluster_project = ClusterProject.where(project_id: @project.id, cluster_id: @cluster.id).first
    @account = Account.where(user_id: @user.id, project_id: @project.id).first
    @cluster_user = ClusterUser.where(cluster_project_id: @cluster_project.id, account_id: @account.id).first
    @access = Access.where(cluster_user_id: @cluster_user.id, credential_id: @credential.id).first
  end
  
  class << self
    delegate *MODELS, to: :new
  end
end
