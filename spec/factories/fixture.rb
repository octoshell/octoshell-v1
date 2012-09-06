class Fixture
  MODELS = [:user, :project, :cluster, :credential, :cluster_project,
    :account, :access, :cluster_user, :request]
  
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
    @request = FactoryGirl.create(:request, cluster_project_id: @cluster_project.id, user: @project.user)
  end
  
  class << self
    delegate *MODELS, to: :new
    
    def active_access
      fixture = new
      fixture.access.activate!
      fixture.access.complete_activation!
      fixture.access
    end
    
    def active_account
      fixture = new
      fixture.account.activate!
      fixture.access.reload.complete_activation!
      fixture.account
    end
    
    def active_cluster_user
      fixture = new
      fixture.cluster_user.activate
      fixture.cluster_user.complete_activation
      fixture.cluster_user
    end
    
    def active_request
      fixture = new
      fixture.request.activate!
      fixture.cluster_project.reload.complete_activation!
      fixture.cluster_user.reload.complete_activation!
      fixture.access.reload.complete_activation!
      fixture.request
    end
  end
end
