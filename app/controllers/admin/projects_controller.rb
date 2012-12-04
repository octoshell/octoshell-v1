# coding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index, if: :admin?
  
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
    respond_to do |format|
      format.html
      format.json { render json: @project }
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
      @project.user.track! :update_project, @project, current_user
      redirect_to @project
    else
      render :edit
    end
  end
  
  def close
    @project = Project.find(params[:project_id])
    authorize! :close, @project
    if @project.close
      @project.user.track! :close_project, @project, current_user
      redirect_to @project
    else
      redirect_to @project, alert: @full_messages.join(', ')
    end
  end
  
  def invite
    @project = Project.find(params[:project_id])
    authorize! :invite, @project
    
    @account = @project.accounts.build
    @surety = @project.build_additional_surety
    @surety.surety_members.build
  end
  
  def sureties
    @project = Project.find(params[:project_id])
    authorize! :sureties, @project
    
    @surety = @project.sureties.build(params[:surety])
    if @surety.save
      redirect_to @project
    else
      @account = @project.accounts.build
      render :invite
    end
  end
  
  def accounts
    @project = Project.find(params[:project_id])
    authorize! :accounts, @project
    
    if params[:account][:user_id].present?
      conditions = { user_id: params[:account][:user_id] }
      @account = @project.accounts.where(conditions).first_or_create!
      redirect_to(@project) and return if @account.active? || @account.activate!
    end
    
    @account = @project.accounts.build
    @surety = @project.build_additional_surety
    render :invite
  end
  
private
  
  def namespace
    :admin
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
    params[:search][:meta_sort] ||= 'name.asc'
  end
end
