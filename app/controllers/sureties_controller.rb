class SuretiesController < ApplicationController
  before_filter :require_login
  
  def new
    @surety = current_user.sureties.build
  end
  
  def create
    @surety = current_user.sureties.build(params[:surety])
    if @surety.save
      redirect_to profile_path
    else
      render :new
    end
  end
  
  def show
    @surety = current_user.sureties.find(params[:id])
  end
end
