class Admin::NoticesController < Admin::ApplicationController
  def index
    @notices = Notice.order("id desc")
  end
  
  def show
    @notice = Notice.find(params[:id])
  end
  
  def new
    @notice = Notice.new
  end
  
  def create
    @notice = Notice.new(params[:notice], as: :admin)
    if @notice.save
      redirect_to [:admin, @notice]
    else
      render :new
    end
  end
  
  def edit
    @notice = Notice.find(params[:id])
  end
  
  def update
    @notice = Notice.find(params[:id])
    if @notice.update_attributes(params[:notice], as: :admin)
      redirect_to [:admin, @notice]
    else
      render :edit
    end
  end
  
  def deliver
    @notice = Notice.find(params[:id])
    @notice.deliver
    redirect_to [:admin, @notice]
  end
  
  def destroy
    @notice = Notice.find(params[:id])
    @notice.destroy
    redirect_to admin_notices_path
  end
  
  def remove_user
    @notice = Notice.find(params[:notice_id])
    @notice.user_notices.where(user_id: params[:user_id]).destroy_all
    redirect_to [:admin, @notice]
  end
  
  def add_all_recipients
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:all).ids
    redirect_to [:admin, @notice]
  end
  
  def remove_all_recipients
    @notice = Notice.find(params[:notice_id])
    @notice.remove_users
    redirect_to [:admin, @notice]
  end
  
  def add_user
    @notice = Notice.find(params[:notice_id])
    @notice.add_users [params[:user_id]]
    redirect_to [:admin, @notice]
  end
  
  def add_from_cluster
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:from_cluster, params[:id]).ids
    redirect_to [:admin, @notice]
  end
  
  def add_with_projects
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:with_projects).ids
    redirect_to [:admin, @notice]
  end
  
  def add_with_accounts
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:with_accounts).ids
    redirect_to [:admin, @notice]
  end
  
  def add_with_refused_accounts
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:with_refused_accounts).ids
    redirect_to [:admin, @notice]
  end
  
  def add_from_session
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:from_session, params[:id]).ids
    redirect_to [:admin, @notice]
  end
  
  def add_unsuccessful_of_current_session
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:unsuccessful_of_current_session).ids
    redirect_to [:admin, @notice]
  end
  
  def add_from_project
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:from_project, params[:project_id]).ids
    redirect_to [:admin, @notice]
  end
  
  def add_from_organization
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:from_organization, params[:organization_id]).ids
    redirect_to [:admin, @notice]
  end
  
  def add_from_organization_kind
    @notice = Notice.find(params[:notice_id])
    @notice.add_users UsersFilter.new(:from_organization_kind, params[:organization_kind_id]).ids
    redirect_to [:admin, @notice]
  end
  
  private
  def default_breadcrumb
    false
  end
end
