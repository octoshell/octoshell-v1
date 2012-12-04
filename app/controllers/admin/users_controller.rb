class UsersController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    respond_to do |format|
      format.html do
        @search = User.includes(:membershiped_organizations).search(params[:search])
        @users = show_all? ? @search.all : @search.page(params[:page])
      end
      format.json do
        @users = User.use_scope(params[:scope]).order('last_name asc, first_name asc').finder(params[:q])
        render json: { records: @users.page(params[:page]).per(params[:per]).as_json(for: :ajax), total: @users.count }
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
    
  def edit
    @user = User.find(params[:id])
    @user.additional_emails.build
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], as_role)
      redirect_to @user
    else
      render :edit
    end
  end
  
  def close
    @user = User.find(params[:user_id])
    @user.close
    redirect_to @user
  end
  
  def history
    @user = User.find(params[:user_id])
    @history_items = @user.history_items.order(:id)
  end
  
private
  
  def namespace
    :admin
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['sured'] }
    params[:search][:meta_sort] ||= 'last_name.asc'
  end
end
