class Admin::UsersController < Admin::ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  before_filter { authorize! :manage, :users }
  
  def index
    @search = User.includes(:membershiped_organizations).search(params[:search])
    @users = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
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
    @history_items = @user.history_items.order(:id)
  end
  
private
  
  def setup_default_filter
    params[:search] ||= {
      state_in: ['sured'],
      user_groups_group_name_in: ['authorized', 'superadmins']
    }
    params[:search][:meta_sort] ||= 'last_name.asc'
  end
end
