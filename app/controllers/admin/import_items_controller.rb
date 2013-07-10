# encoding: utf-8
class Admin::ImportItemsController < Admin::ApplicationController
  def index
  end
  
  def new
    @import = ImportItem.new
  end
  
  def create
    if ImportItem.create_by_file_and_cluster(params[:import_item])
      redirect_to step_admin_import_items_path
    else
      redirect_to new_admin_import_item_path
    end
  rescue => e
    notify_airbrake(e) if Rails.env.production?
    flash.now[:alert] = e.message
    @import = ImportItem.new
    render :new
  end
  
  def step
    @import = ImportItem.order(:id).first
    redirect_to admin_import_items_path, notice: 'Нечего импортировать' unless @import
  end
  
  def import
    @import = ImportItem.find(params[:import_item_id])
    if @import.import params[:import_item], as: :admin
      redirect_to step_admin_import_items_path
    else
      render :step
    end
  rescue => e
    notify_airbrake(e) if Rails.env.production?
    flash.now[:alert] = e.message
    render :step
  end
  
  def destroy
    @import = ImportItem.find(params[:id])
    @import.destroy
    redirect_to step_admin_import_items_path
  end
end
