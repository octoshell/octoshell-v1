# coding: utf-8
class Admin::ProjectsController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  before_filter { authorize! :manage, :projects }
  
  def index
    respond_to do |format|
      format.html do
        @search = Project.search(params[:search])
        @projects = show_all? ? @search.all : @search.page(params[:page])
      end
      format.json do
        @projects = Project.finder(params[:q]).order('projects.name asc')
        render json: { records: @projects.page(params[:page]).per(params[:per]), total: @projects.count }
      end
    end
  end
  
  def show
    @project = Project.find(params[:id])
    @project_mover = ProjectMover.new(@project)
    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project], as: :admin)
      @project.user.track! :update_project, @project, current_user
      redirect_to [:admin, @project]
    else
      render :edit
    end
  end
  
  def move
    @user = User.find(params[:project_mover][:user_id])
    @project = Project.find(params[:project_id])
    @project_mover = ProjectMover.new(@project, @user)
    if @project_mover.move
      redirect_to [:admin, @project]
    else
      flash.now[:alert] = @project_mover.error
      render :show
    end
  end
  
  def close
    @project = Project.find(params[:project_id])
    if @project.close
      @project.user.track! :close_project, @project, current_user
      redirect_to [:admin, @project]
    else
      redirect_to [:admin, @project], alert: @full_messages.join(', ')
    end
  end
  
  def sureties
    @project = Project.find(params[:project_id])
    
    @surety = @project.sureties.build(params[:surety])
    if @surety.save
      redirect_to [:admin, @project]
    else
      @account = @project.accounts.build
      render :invite
    end
  end
  
  def accounts
    @project = Project.find(params[:project_id])
    
    if params[:account][:user_id].present?
      conditions = { user_id: params[:account][:user_id] }
      @account = @project.accounts.where(conditions).first_or_create!
      redirect_to([:admin, @project]) and return if @account.active? || @account.activate!
    end
    
    @account = @project.accounts.build
    @surety = @project.build_additional_surety
    render :invite
  end
  
private

  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
    params[:search][:meta_sort] ||= 'name.asc'
  end
end
