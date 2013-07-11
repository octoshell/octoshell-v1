class ProjectsController < ApplicationController
  before_filter :require_login
  
  def index
    @projects = current_user.all_projects.without_state(:closed).reorder('projects.id desc')
    @project_joiner = ProjectJoiner.new
    @project_joiner.user_id = current_user.id
    respond_to do |format|
      format.html
      format.json do
        @projects = Project.finder(params[:q]).reorder('projects.title asc')
        render json: { records: @projects.page(params[:page]).per(params[:per]), total: @projects.count }
      end
    end
  end
  
  def show
    respond_to do |format|
      format.html do
        @project = find_project(params[:id])
        redirect_to projects_path if @project.closed?
      end
      format.json do
        @project = Project.find(params[:id])
        render json: @project
      end
    end
  end
  
  def new
    @project = current_user.owned_projects.build
    @project.build_card
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
      redirect_to @project, notice: %(Проект "#{@project.title}" создан)
    else
      render :new
    end
  end
  
  def members
    @project = current_user.owned_projects.find(params[:project_id])
    @inviter = ProjectInviter.new(@project, params[:members])
    if @inviter.invite
      @project.user.track! :invite_members, params[:members], current_user
      redirect_to @project, notice: 'Участники добавлены'
    else
      redirect_to @project, alert: 'Не верно заполнены поля'
    end
  end
  
  def new_members_csv
  end
  
  def members_csv
    @project = current_user.owned_projects.find(params[:project_id])
    @inviter = ProjectInviter.csv(@project, params[:members].read)
    if @inviter.invite
      redirect_to @project, notice: 'Участники добавлены'
    else
      redirect_to project_members_csv_path(@project), alert: 'Не верно заполнены поля'
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
    if @project.close
      @project.user.track! :mark_to_close_project, @project, current_user
      redirect_to @project
    else
      flash.now[:alert] = t('.wrong_confirmation_code', default: 'Wrong confirmation code')
    end
  end
  
  def close_confirmation
    @project = find_project(params[:project_id])
    add_breadcrumb @project.title, @project
    add_breadcrumb 'Завершение проекта'
    render :close
  end
  
  def sureties
    @project = find_project(params[:project_id])
    @project.generate_surety
    redirect_to project_path(@project, anchor: "new-surety")
  end
  
private

  def find_project(id)
    current_user.all_projects.enabled.find(id)
  end
  
  def namespace
    may?(:access, :admin) ? :dashboard : :projects
  end
end
