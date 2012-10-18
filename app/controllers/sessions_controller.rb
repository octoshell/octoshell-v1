class SessionsController < ApplicationController
  before_filter :handle_authorized, if: :logged_in?, except: [:destroy, :become, :revert]
  
  def new
    @user = User.new
  end
  
  def create
    email, password, remember = fetch_user(params[:user])
    if @user = login(email, password, remember)
      @user.track! :create_session, @user, current_user
      redirect_to root_url
    else
      @user = User.initialize_with_auth_errors(email)
      flash.now[:alert] = @user.errors.full_messages.join(', ')
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to root_path
  end
  
  def become
    user = User.find(params[:user_id])
    session[:soul_id] = current_user.id
    auto_login(user)
    redirect_to root_path
  end
  
  def revert
    auto_login(User.find(session.delete(:soul_id)))
    redirect_to root_path
  end
  
private

  def handle_authorized
    redirect_to after_login_path
  end
  
  def fetch_user(hash)
    [hash[:email], hash[:password], hash[:remember]]
  end
end
