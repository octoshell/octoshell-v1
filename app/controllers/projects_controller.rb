# coding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_login
  
  def index
    @projects = current_user.all_projects.reorder('projects.id desc')
    respond_to do |format|
      format.html
      format.json do
        @projects = Project.finder(params[:q]).reorder('projects.name asc')
        render json: { records: @projects.page(params[:page]).per(params[:per]), total: @projects.count }
      end
    end
  end
  
  def show
    respond_to do |format|
      format.html { @project = find_project(params[:id]) }
      format.json do
        @project = Project.find(params[:id])
        render json: @project
      end
    end
  end
  
  def new
    @project = current_user.owned_projects.build
    @project.sureties.build do |surety|
      surety.surety_members.build do |member|
        member.email = current_user.email
        member.full_name = current_user.full_name
      end
    end unless @project.user.sured?
  end
  
  def create
    @project = current_user.owned_projects.build(params[:project])
    if @project.save
      @project.user.track! :create_project, @project, current_user
      redirect_to @project
    else
      render :new
    end
  end
  
  def edit
    @project = find_project(params[:id])
  end
  
  def update
    @project = find_project(params[:id])
    if @project.update_attributes(params[:project])
      @project.user.track! :update_project, @project, current_user
      redirect_to @project
    else
      render :edit
    end
  end
  
  def close
    @project = find_project(params[:project_id])
    code = params[:project][:confirmation_code]
    if @project.valid_to_close?(code) && @project.mark_to_close
      @project.user.track! :close_project, @project, current_user
      redirect_to @project, notice: t('.project_successfully_closed', default: 'Project successfully closed')
    else
      flash.now[:alert] = t('.wrong_confirmation_code', default: 'Wrong confirmation code')
    end
  end
  
  def invite
    @project = find_project(params[:project_id])
    @account = @project.accounts.build
    @surety = @project.build_additional_surety
    @surety.surety_members.build
  end
  
  def sureties
    @project = find_project(params[:project_id])
    @surety = @project.sureties.build(params[:surety])
    if @surety.save
      redirect_to @project, notice: t('.surety_created', default: "Surety has been created")
    else
      @account = @project.accounts.build
      render :invite
    end
  end
  
  def accounts
    @project = find_project(params[:project_id])
    if params[:account][:user_id].present?
      conditions = { user_id: params[:account][:user_id] }
      @account = @project.accounts.where(conditions).first_or_create!
      redirect_to(@project, notice: t('.user_invited', default: "%{name} invited to the project", name: @account.user.full_name)) and return if @account.active? || @account.activate!
    end
    
    @account = @project.accounts.build
    @surety = @project.build_additional_surety
    render :invite
  end
  
  def close_confirmation
    @project = find_project(params[:project_id])
    render :close
  end
  
private

  def find_project(id)
    current_user.all_projects.find(id)
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
    params[:q][:meta_sort] ||= 'name.asc'
  end
end
