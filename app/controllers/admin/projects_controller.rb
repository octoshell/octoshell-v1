# coding: utf-8
class Admin::ProjectsController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    respond_to do |format|
      format.html do
        @search = Project.search(params[:q])
        search_result = @search.result(distinct: true)
        @projects = show_all? ? search_result : search_result.page(params[:page])
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
  
  def synch
    @project = Project.find(params[:project_id])
    @project.requests.with_state(:active).each &:request_maintain!
    redirect_to [:admin, @project]
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
  
  def close
    @project = Project.find(params[:project_id])
    if @project.close
      @project.user.track! :close_project, @project, current_user
      redirect_to [:admin, @project]
    else
      redirect_to [:admin, @project], alert: @project.errors.full_messages.join(', ')
    end
  end
  
  def erase
    @project = Project.find(params[:project_id])
    if @project.erase
      @project.user.track! :erase_project, @project, current_user
      redirect_to [:admin, @project]
    else
      redirect_to [:admin, @project], alert: @project.errors.full_messages.join(', ')
    end
  end
  
  def enable
    @project = Project.find(params[:project_id])
    @project.update_column :disabled, false
    redirect_to [:admin, @project]
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
  
  def move_to
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    @project.move_to(@user)
    redirect_to [:admin, @project]
  end
  
  def block
    @project = Project.find(params[:project_id])
    @project.block(params[:description])
    redirect_to [:admin, @project]
  end
  
  private
  def default_breadcrumb
    false
  end

  def setup_default_filter
    params[:q] ||= { state_in: ['active'], disabled_eq: false }
    params[:q][:meta_sort] ||= 'name.asc'
  end
end
