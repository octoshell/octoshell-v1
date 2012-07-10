class ConfirmationsController < ApplicationController
  before_filter :require_login
  
  def new
    @confirmation = current_user.confirmations.build
  end
  
  def create
    @confirmation = current_user.confirmations.build(params[:confirmation])
    if @confirmation.save
      redirect_to profile_path
    else
      render :new
    end
  end
  
  def show
    @confirmation = current_user.confirmations.find(params[:id])
  end
end
