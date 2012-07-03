class ProjectsController < ApplicationController
  before_filter :require_login
  
  def index
    @projects = current_user.projects
  end
  
  def new
    @project = Project.new
    @project.requests.build
  end
  
  def create
    @project = Project.new(params[:project])
    if @project.save!
      redirect_to request_confirmation_path(@project.requests.first)
    else
      render :new
    end
  end
  
  def show
    @project = current_user.projects.find(params[:id])
  end
end
