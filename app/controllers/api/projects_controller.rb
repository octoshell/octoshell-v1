class Api::ProjectsController < Api::ApplicationController
  def index
    @projects = Project.search(params[:search]).result(distinct: true).
      page(params[:page]).per(params[:per])
    
    respond_with(@projects.map do |project|
      {
        id: project.id,
        title: project.title,
        group: project.login,
        state: project.state,
        organization_id: project.organization_id,
        user_id: project.user_id
      }
    end)
  end
  
  def show
    @project = Project.find(params[:id])
    
    respond_with(
      id: @project.id,
      title: @project.title,
      group: @project.login,
      state: @project.state,
      organization_id: @project.organization_id,
      user_id: @project.user_id,
      accounts: (@project.accounts.map do |account|
        {
          id: account.id,
          user_id: account.user_id,
          project_id: account.project_id,
          login: account.username,
          cluster_state: account.cluster_state,
          access_state: account.access_state
        }
      end),
      requests: (@project.requests.map do |request|
        {
          id: request.id,
          project_id: request.project_id,
          cluster_id: request.cluster_id,
          cpu_hours: request.cpu_hours,
          gpu_hours: request.gpu_hours,
          size: request.size,
          state: request.state
        }
      end)
    )
  end
end
