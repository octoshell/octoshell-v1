class UsersController < ApplicationController
  before_filter :require_login, only: [:show, :index, :edit, :update, :close]
  before_filter :logout, except: [:show, :index, :edit, :update, :close, :history, :email]
  before_filter :setup_default_filter, only: :index
  
  def new
    @user = User.new
  end
  
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
    authorize! :show, @user
    
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      @user.track! :registration, @user, @user
      redirect_to confirmation_users_path(email: @user.email)
    else
      render :new
    end
  end
  
  def activate
    @user = User.load_from_activation_token(params[:token])
    if @user
      @user.activate!
      auto_login @user
      flash[:notice] = t('flash.user_is_activated')
      redirect_to after_login_path
    else
      not_authenticated
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
  
  def confirmation
  end
  
  def close
    authorize! :close, :users
    @user = User.find(params[:user_id])
    @user.close
    redirect_to @user
  end
  
  def history
    @user = User.find(params[:user_id])
    @history_items = @user.history_items.order(:id)
  end
  
  def email
    if user = User.find_by_email(params[:email].strip.downcase)
      render json: { full_name: user.full_name }
    else
      render json: {}
    end
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['sured'] }
    params[:search][:meta_sort] ||= 'last_name.asc'
  end
  
  def skip_authentication_by_token
    params[:action] == 'activate'
  end
end
