class UsersController < ApplicationController
  before_filter :require_login, only: [:show, :index, :edit, :update, :close]
  before_filter :logout, except: [:show, :index, :edit, :update, :close]
  before_filter :setup_default_filter, only: :index
  
  def new
    @user = User.new
  end
  
  def index
    respond_to do |format|
      format.html do
        @search = User.order('last_name asc, first_name asc').search(params[:search])
        @users = show_all? ? @search.all : @search.page(params[:page])
      end
      format.json do
        @users = User.order('last_name asc, first_name asc').
          finder(params[:q]).page(params[:page]).per(params[:per])
        
        render json: @users
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
    authorize! :show, @user
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
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
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['sured'] }
  end
  
  def skip_authentication_by_token
    params[:action] == 'activate'
  end
end
