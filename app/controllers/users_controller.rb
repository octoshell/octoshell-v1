class UsersController < ApplicationController
  before_filter :logout, except: [:index, :email, :show]
  before_filter :setup_default_filter, only: :index
  
  def new
    @user = User.new
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

  def index
    respond_to do |format|
      format.json do
        User.extend(UserScopable)
        @users = User.without_state(:closed).use_scope(params[:scope]).order('last_name asc, first_name asc').finder(params[:q])
        render json: { records: @users.page(params[:page]).per(params[:per]).as_json(for: :ajax), total: @users.count }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json { render json: @user.as_json(for: :ajax) }
    end
  end
  
  def activate
    @user = User.load_from_activation_token(params[:token])
    if @user
      @user.activate!
      @user.track! :activation, @user, @user
      auto_login @user
      flash[:notice] = t('flash.user_is_activated')
      redirect_to after_login_path
    else
      not_authenticated
    end
  end
  
  def confirmation
  end
  
  def email
    if user = User.find_by_email(params[:email].strip.downcase)
      render json: { full_name: user.full_name }
    else
      render json: {}
    end
  end
  
private

  def setup_default_filter
    params[:q] ||= { state_in: ['sured'] }
    if params[:q].is_a? Hash
      params[:q][:meta_sort] ||= 'last_name.asc'
    end
  end  
end
