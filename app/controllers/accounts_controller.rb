class AccountsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Account.search(params[:search])
    @accounts = @search.page(params[:page])
  end
  
  def new
    @account = Account.new
  end
  
  def create
    @account = Account.by_params(params[:account]).first_or_create!
    @account.active? or @account.activate!
    redirect_to @account
  end
  
  def show
    @account = find_account(params[:id])
  end
  
  def activate
    @account = find_account(params[:account_id])
    authorize! :activate, @account
    if @account.activate
      Mailer.account_activated(@account).deliver!
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
  end
  
  def update
    @account = find_account(params[:id])
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
    params[:search] ||= { state_in: ['active'] }
  end
  
  def skip_action?
    %w(invite application mailer).include? params[:action]
  end
end
