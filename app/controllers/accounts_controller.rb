class AccountsController < ApplicationController
  def new
    @account = current_user.accounts.build
    @invite = current_user.accounts.build
    authorize! :create, @account
    authorize! :create, @invite
  end
  
  def create
    @account = current_user.accounts.build(params[:account])
    if @account.save
      redirect_to dashboard_path
    else
      @invite = current_user.account.build
      render :new
    end
  end
  
  def invite
    @invite = current_user.accounts.build(params[:account])
    if @invite.save
      redirect_to dashboard_path
    else
      @account = current_user.account.build
      render :new
    end
  end
  
  def activate
    @account = find_account(params[:account_id])
    authorize! :activate, @account
    if @account.activate
      redirect_to dashboard_path
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
  def decline
    @account = find_account(params[:account_id])
    authorize! :decline, @account
    if @account.decline
      redirect_to dashboard_path
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
  def cancel
    @account = find_account(params[:account_id])
    authorize! :cancel, @account
    if @account.cancel
      redirect_to dashboard_path
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
end
