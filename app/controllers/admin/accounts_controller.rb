class Admin::AccountsController < Admin::ApplicationController
  before_filter { authorize! :manage, :projects }
  
  def change
    @account = Account.find(params[:account_id])
    if @account.change_login(params[:username])
      redirect_to [:admin, @account.project], notice: "Логин изменен"
    else
      redirect_to [:admin, @account.project], alert: @account.errors.full_messages.to_sentence
    end
  end
end
