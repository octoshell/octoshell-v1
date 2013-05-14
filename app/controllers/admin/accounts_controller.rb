class Admin::AccountsController < Admin::ApplicationController
  before_filter { authorize! :manage, :projects }
  
  def change
    @account = Accout.find(params[:account_id])
    if @account.change_login(params[:login])
      redirect_to [:admin, @account.project], notice: "Логин изменен"
    else
      redirect_to [:admin, @account.project], alert: "Не удалось изменить логин"
    end
  end
end
