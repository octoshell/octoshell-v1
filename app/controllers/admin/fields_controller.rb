class Admin::FieldsController < ApplicationController
  def index
    @fields = Field.order(:position).group_by &:model_type
  end
  
  def new
    @field = Field.new
  end
  
  def create
    @field = Field.new(params[:field], as: :admin)
    if @field.save
      redirect_to admin_fields_path
    else
      render :new
    end
  end
  
  def edit
    @field = find_field(params[:id])
  end
  
  def update
    @field = find_field(params[:id])
    if @field.update_attributes(params[:field], as: :admin)
      redirect_to admin_fields_path
    else
      render :edit
    end
  end
  
  def destroy
    @field = find_field(params[:id])
    @field.destroy
  end
  
protected
  
  def find_field(id)
    Field.find(id)
  end
end
