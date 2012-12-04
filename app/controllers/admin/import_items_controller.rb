# encoding: utf-8
class ImportItemsController < ApplicationController
  def index
  end
  
  def new
    @import = ImportItem.new
  end
  
  def create
    if ImportItem.create_by_file_and_cluster(params[:import_item])
      redirect_to step_import_items_path
    else
      redirect_to new_import_item_path
    end
  end
  
  def step
    @import = ImportItem.order(:id).first
    redirect_to import_items_path, notice: 'Нечего импортировать' unless @import
  end
  
  def import
    @import = ImportItem.find(params[:import_item_id])
    if @import.import params[:import_item], as_role
      redirect_to step_import_items_path
    else
      render :step
    end
  end
  
  def destroy
    @import = ImportItem.find(params[:id])
    @import.destroy
    redirect_to step_import_items_path
  end
  
private
  
  def namespace
    :admin
  end
end
