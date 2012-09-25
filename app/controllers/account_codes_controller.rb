# coding: utf-8
class AccountCodesController < ApplicationController
  def index
    @account_codes = current_user.produces_account_codes
  end
  
  def new
    @account_code = AccountCode.new
  end
  
  def create
    @account_code = AccountCode.new(params[:account_code], as_role)
    authorize! :create, @account_code
    if @account_code.save
      redirect_to account_codes_path
    else
      render :new
    end
  end
  
  def new_use
  end
  
  def use
    @account_code = AccountCode.find_by_code(params[:code])
    if @account_code
      if @account_code.use(current_user)
        redirect_to projects_path, notice: 'Вы активировали код'
      else
        flash.now[:alert] = @account_code.errors.full_messages.join(', ')
        render :new_use
      end
    else
      flash.now[:alert] = 'Код не найден'
      render :new_use
    end
  end
  
  def destroy
    @account_code = AccountCode.find(params[:id])
    authorize! :destroy, @account_code
    @account_code.destroy
    redirect_to account_codes_path
  end
  
private
  
  def namespace
    admin? ? :admin : :dashboard
  end
end
