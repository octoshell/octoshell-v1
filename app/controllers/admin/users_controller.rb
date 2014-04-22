class Admin::UsersController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  before_filter { authorize! :manage, :users }
  
  def index
    @search = User.includes(:membershiped_organizations).search(params[:q]).result
    @users = show_all? ? @search : @search.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @user.extend(Avatarable)
    add_breadcrumb "Список", admin_users_path
    add_breadcrumb @user.full_name
  end
  
  def edit
    @user = User.find(params[:id])
    @user.additional_emails.build
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], as: :admin)
      redirect_to [:admin, @user]
    else
      render :edit
    end
  end
  
  def close
    @user = User.find(params[:user_id])
    @user.close
    redirect_to [:admin, @user]
  end
  
  def history
    @user = User.find(params[:user_id])
    @history_items = @user.history_items.order(:created_at)
  end
  
  def delivered_mails
    @user = User.find(params[:user_id])
    @delivered_mails = @user.delivered_mails.order("id desc")
    add_breadcrumb "Список", admin_users_path
    add_breadcrumb @user.full_name, [:admin, @user]
    add_breadcrumb "Отправленные письма"
  end
  
private
  
  def default_breadcrumb
    false
  end
  
  def setup_default_filter
    params[:q] ||= {
      state_in: ['sured'],
      user_groups_group_name_in: ['authorized', 'superadmins']
    }
    params[:q][:meta_sort] ||= 'last_name.asc'
  end
end
