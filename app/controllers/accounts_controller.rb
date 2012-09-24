class AccountsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    authorize! :index, :accounts
    if current_user.admin?
      @search = Account.search(params[:search])
      @accounts = @search.page(params[:page])
    else
      @search = Account.where(project_id: current_user.owned_project_ids).search(params[:search])
      @accounts = @search.page(params[:page])
    end
  end
  
  def new
    authorize! :new, :accounts
    @application = Account.new
    @invite = Account.new
    @mailer = Account.new
    @projects = get_projects
  end
  
  def show
    @account = find_account(params[:id])
    authorize! :show, @account
  end
  
  def application
    @application = Account.find_by_params(params[:account])
    authorize! :application, @application
    authorize! :request, @application
    if @application.requested? || @application.request
      UserMailer.account_requested(@application).deliver!
      redirect_to @application
    else
      flash.now[:alert] = @application.errors.full_messages.join(', ')
      @invite = Account.new
      @mailer = Account.new
      @projects = get_projects
      render :new
    end
  end
  
  def invite
    @invite = Account.find_by_params(params[:account])
    authorize! :invite, @invite
    if @invite.active? || @invite.activate
      UserMailer.account_activated(@invite).deliver!
      redirect_to @invite
    else
      @application = Account.new
      @mailer = Account.new
      @projects = get_projects
      render :new
    end
  end
  
  def mailer
    @mailer = Account.find_by_params(params[:account])
    if @mailer.send_invites
      redirect_to @mailer.project
    else
      @application = Account.new
      @invite = Account.new
      @projects = get_projects
      render :new
    end
  end
  
  def activate
    @account = find_account(params[:account_id])
    authorize! :activate, @account
    if @account.activate
      UserMailer.account_activated(@account).deliver!
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
      redirect_to :back
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
  def edit
    @account = find_account(params[:id])
    authorize! :edit, @account
  end
  
  def update
    @account = find_account(params[:id])
    authorize! :update, @account
    if @account.update_attributes(params[:account], as_role)
      redirect_to @account
    else
      render :update
    end
  end
  
private

  def find_account(id)
    Account.find(id)
  end
  
  def redirect_to_account_with_alert(account)
    redirect_to account, alert: account.errors.full_messages.join(', ')
  end
  
  def skip_action?
    params[:action] == 'new' && logged_in?
  end
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def get_projects
    admin? ? Project.active : current_user.owned_projects.active
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['requested', 'active'] }
  end
  
  def skip_action?
    %w(invite application mailer).include? params[:action]
  end
end
