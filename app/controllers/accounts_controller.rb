class AccountsController < ApplicationController
  before_filter :require_login

  def deny
    @account = find_account(params[:account_id])
    if @account.denied? || @account.deny
      redirect_to @account.project
    else
      redirect_to @account.project, alert: @account.errors.full_messages.to_sentence
    end
  end
  
private

  def find_account(id)
    current_user.managed_accounts.find(id)
  end
end
