# coding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index, if: :admin?
  
  def index
    respond_to do |format|
      format.html do
        if admin?
          @search = Project.search(params[:search])
          @projects = show_all? ? @search.all : @search.page(params[:page])
        else
          @projects = current_user.all_projects.reorder('projects.id desc')
        end
      end
      format.json do
        if admin?
          @projects = Project.finder(params[:q]).order('projects.name asc')
          render json: { records: @projects.page(params[:page]).per(params[:per]), total: @projects.count }
        else
          @projects = current_user.all_projects.finder(params[:q]).order('projects.name asc')
          render json: { records: @projects.page(params[:page]).per(params[:per]), total: @projects.count }
        end
      end
    end
  end
  
  def show
    @project = Project.find(params[:id])
    authorize! :show, @project
    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end
  
  def new
    @project = Project.new
    @project.user = current_user
    @project.sureties.build do |surety|
      surety.surety_members.build do |member|
        member.email = current_user.email
        member.full_name = current_user.full_name
      end
    end unless @project.user.sured?
  end
  
  def create
    @project = Project.new(params[:project], as_role)
    @project.user = current_user unless admin?
    @project.accounts.build { |a| a.user = @project.user }
    if @project.save
      @project.user.track! :create_project, @project, current_user
      redirect_to @project
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

  def join
    authorize! :accounts, :projects
    @project = Project.find(params[:project_id])
  end

  def create_account
    @project = Project.find(params[:project_id])
    authorize! :create_account, @project
    @account_code = @project.account_codes.find_by_code(params[:code])
    if @account_code
      if @account_code.use(current_user)
        @account_code.project.user.track! :use_account_code, @account_code, current_user
        redirect_to projects_path, notice: 'Вы активировали код'
      else
        flash.now[:alert] = @account_code.errors.full_messages.join(', ')
        render :join
      end
    else
      flash.now[:alert] = 'Код не найден'
      render :join
    end
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
    params[:search][:meta_sort] ||= 'name.asc'
  end
end
