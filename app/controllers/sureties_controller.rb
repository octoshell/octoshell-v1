# coding: utf-8
class SuretiesController < ApplicationController
  before_filter :require_login
  
  def show
    @surety = find_surety(params[:id])
    add_breadcrumb "Проект: #{@surety.project.title}", @surety.project
    add_breadcrumb "Поручительство ##{@surety.id}"
    respond_to do |format|
      format.html
      format.rtf do
        send_data @surety.to_rtf
      end
    end
  end
  
  def generate
    @surety = find_surety(params[:surety_id])
    @surety.assign_attributes(params[:surety])
    if @surety.generated? || @surety.generate
      redirect_to @surety
    else
      redirect_to @project
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
    Surety.where(project_id: current_user.owned_project_ids).find(id)
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
end
