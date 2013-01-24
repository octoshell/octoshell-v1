# coding: utf-8
class SuretiesController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = current_user.sureties.search(params[:search])
    @sureties = @search.page(params[:page])
  end
  
  def show
    @surety = find_surety(params[:id])
    respond_to do |format|
      format.html
      format.rtf do
        send_data @surety.to_rtf
      end
    end
  end
  
  def activate
    @surety = find_surety(params[:surety_id])
    if @surety.activate
      @surety.user.track! :activate_surety, @surety, current_user
      redirect_to_surety(@surety)
    else
      redirect_to_surety_with_alert(@surety)
    end
  end
  
  def close
    @surety = find_surety(params[:surety_id])
    if @surety.close
      @surety.user.track! :close_surety, @surety, current_user
      redirect_to_surety(@surety, notice: t('.surety_closed', default: 'Surety successfully closed'))
    else
      redirect_to_surety_with_alert(@surety)
    end
  end

  def load_scan
    @surety = Surety.find(params[:surety_id])
    if @surety.load_scan(params[:file])
      @surety.user.track! :create_scan, @surety, current_user
      redirect_to @surety
    else
      redirect_to [@surety, :scan], alert: @surety.errors.full_messages.join(', ')
    end
  end
  
  def new_scan
    @surety = Surety.find(params[:surety_id])
  end
  
private
  
  def find_surety(id)
    current_user.sureties.find(id)
  end
  
  def redirect_to_surety_with_alert(surety)
    redirect_to surety, alert: surety.errors.full_messages.join(', ')
  end
  
  def redirect_to_surety(surety, options = {})
    redirect_to surety, options
  end
  
  def namespace
    :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['pending', 'active', 'confirmed'] }
  end
end
