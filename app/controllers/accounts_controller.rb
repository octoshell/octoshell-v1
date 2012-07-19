class AccountsController < ApplicationController
  before_filter :require_login
  
  def index
    if current_user.admin?
      @accounts = Account.scoped
    else
      @accounts = current_user.all_accounts
    end
  end
  
  def new
    @account = current_user.accounts.build
    @invite = current_user.accounts.build
    @mailer = current_user.accounts.build
    @projects = get_projects
  end
  
  def create
    @account = current_user.accounts.build(params[:account], as_role)
    authorize! :create, @account
    if @account.save
      redirect_to @account
    else
      @invite = current_user.accounts.build
      @mailer = current_user.accounts.build
      @projects = get_projects
      render :new
    end
  end
  
  def show
    @account = find_account(params[:id])
    authorize! :show, @account
  end
  
  def invite
    user_id = params[:account].delete(:user_id)
    @invite = Account.new(params[:account]) do |account|
      account.user_id = user_id
    end
    authorize! :invite, @invite
    if @invite.invite
      redirect_to @invite.project
    else
      @account = current_user.accounts.build
      @mailer = current_user.accounts.build
      @projects = get_projects
      render :new
    end
  end
  
  def mailer
    @mailer = current_user.accounts.build(params[:account])
    authorize! :mailer, @mailer
    if @mailer.send_invites
      redirect_to @mailer.project
    else
      @account = current_user.accounts.build
      @invite = current_user.accounts.build
      @projects = get_projects
      render :new
    end
  end
  
  def activate
    @account = find_account(params[:account_id])
    authorize! :activate, @account
    if @account.activate
      redirect_to @account
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
  def decline
    @account = find_account(params[:account_id])
    authorize! :decline, @account
    if @account.decline
      redirect_to @account
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
  def cancel
    @account = find_account(params[:account_id])
    authorize! :cancel, @account
    if @account.cancel
      redirect_to @account
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
private

  def find_account(id)
    Account.find(id)
  end
  
  def redirect_to_account_with_alert(account)
    redirect_to dashboard_path, alert: account.errors.full_messages.join(', ')
  end
  
  def skip_action?
    params[:action] == 'new' && logged_in?
  end
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def get_projects
    admin? ? Project.all : current_user.owned_projects
  end
end
