class ProjectsController < ApplicationController
  before_filter :require_login
  
  def index
    @projects = current_user.projects
  end
  
  def new
    @project = current_user.owned_projects.build
    @project.requests.build
  end
  
  def create
    @project = current_user.owned_projects.build(params[:project])
    @project.accounts.build { |a| a.user = current_user }
    @project.requests.each { |r| r.user = current_user }
    if @project.save!
      redirect_to dashboard_path
    else
      render :new
    end
  end
  
  def show
    @project = current_user.projects.find(params[:id])
  end
end
