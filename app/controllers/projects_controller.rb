class ProjectsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    if admin?
      @search = Project.search(params[:search])
      @projects = @search.page(params[:page])
    else
      @search = current_user.projects.search(params[:search])
      @projects = @search.page(params[:page])
    end
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def new
    @project = Project.new
    @project.user = current_user unless admin?
    @project.requests.build
    @organizations
  end
  
  def create
    @project = Project.new(params[:project], as_role)
    @project.user = current_user unless admin?
    @project.accounts.build { |a| a.user = @project.user }
    if @project.save
      redirect_to new_request_path(project_id: @project.id)
    else
      render :new
    end
  end
  
  def edit
    @project = Project.find(params[:id])
    authorize! :edit, @project
  end
  
  def update
    @project = Project.find(params[:id])
    authorize! :update, @project
    if @project.update_attributes(params[:project], as_role)
      redirect_to @project
    else
      render :edit
    end
  end
  
  def close
    @project = Project.find(params[:project_id])
    authorize! :close, @project
    if @project.close
      redirect_to @project
    else
      redirect_to @project, alert: @full_messages.join(', ')
    end
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
