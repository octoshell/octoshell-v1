class SuretiesController < ApplicationController
  before_filter :require_login
  
  def index
    if admin?
      @sureties = Surety.all
    else
      @sureties = current_user.sureties
    end
  end
  
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
  
  def index
    @sureties = Surety.order('id desc')
  end
  
  def show
    @surety = find_surety(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "surety#{@surety.id}}",
               layout: 'pdf.html'
      end
    end
  end
  
  def find
    @surety = find_surety(params[:id])
    redirect_to @surety
  rescue ActiveRecord::RecordNotFound
    redirect_to sureties_path, alert: t('flash.alerts.surety_not_found')
  end
  
  def activate
    @surety = find_surety(params[:surety_id])
    if @surety.activate
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def decline
    @surety = find_surety(params[:surety_id])
    if @surety.decline
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def cancel
    @surety = find_surety(params[:surety_id])
    if @surety.cancel
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
private
  
  def find_surety(id)
    Surety.find(id)
  end
  
  def redirect_to_surety_with_alert(surety)
    redirect_to surety, alert: surety.errors.full_messages.join(', ')
  end
  
  def redirect_to_surety(surety)
    redirect_to surety
  end
  
  def namespace
    :profile
  end
end
