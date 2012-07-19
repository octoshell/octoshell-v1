class ProjectsController < ApplicationController
  before_filter :require_login
  
  def index
    if admin?
      @projects = Project.all
    else
      @projects = current_user.projects
    end
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def new
    @project = Project.new
    @project.user = current_user unless admin?
    @project.requests.build
  end
  
  def create
    @project = Project.new(params[:project], as_role)
    @project.user = current_user unless admin?
    @project.accounts.build { |a| a.user = @project.user }
    @project.requests.each { |r| r.user = @project.user }
    if @project.save
      redirect_to @project
    else
      render :new
    end
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project], as_role)
      redirect_to @project
    else
      render :edit
    end
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
end
