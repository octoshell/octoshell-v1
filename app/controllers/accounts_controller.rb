class AccountsController < ApplicationController
  before_filter :require_login

  def cancel
    @account = find_account(params[:account_id])
    authorize! :cancel, @account
    if @account.cancel
      redirect_to :back
    else
      redirect_to_account_with_alert(@account)
    end
  end
  
private

  def find_account(id)
    current_user.managed_accounts.find(id)
  end
end
