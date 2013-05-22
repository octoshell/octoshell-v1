class Admin::AccountsController < Admin::ApplicationController
  before_filter { authorize! :manage, :projects }
  
  def change
    @account = Account.find(params[:account_id])
  end
  
  def change_check
    @account = Account.find(params[:account_id])
    @account.username = params[:username]
    render :change
  end
  
  def change_confirmation
    @account = Account.find(params[:account_id])
    if @account.change_login(params[:username])
      redirect_to [:admin, @account.project], notice: "Логин изменен"
    else
      redirect_to [:admin, @account.project]
    end
  end
end
