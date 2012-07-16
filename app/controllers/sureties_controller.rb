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
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "surety#{@surety.id}}",
               layout: 'pdf.html'
      end
    end
  end
end
