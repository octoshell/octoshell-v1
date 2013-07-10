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
        send_data @surety.to_rtf, filename: "surety_#{@surety.id}.rtf", type: 'application/rtf'
      end
    end
  end
  
  def generate
    @surety = find_surety(params[:surety_id])
    @surety.assign_attributes(params[:surety])
    if @surety.generated? || @surety.generate
      @surety.project.user.track! :generate_surety, @surety, current_user
      redirect_to @surety
    else
      redirect_to @project
    end
  end
  
  def load_scan
    @surety = find_surety(params[:surety_id])
    if @surety.load_scan(params[:file])
      @surety.user.track! :create_scan, @surety, current_user
      redirect_to @surety.project
    else
      redirect_to [@surety, :scan], alert: @surety.errors.full_messages.join(', ')
    end
  end
  
  def new_scan
    @surety = find_surety(params[:surety_id])
  end
  
  private
  def find_surety(id)
    Surety.where(project_id: current_user.owned_project_ids).find(id)
  end
end
