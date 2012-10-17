class PositionNamesController < ApplicationController
  before_filter :require_login
  
  def index
    @position_names = PositionName.all
  end
  
  def autocomplete
    @position_name = PositionName.find(params[:position_name_id])
    render(
      json: @position_name.values(params[:q]), 
      total: @position_name.available_values.size
    )
  end
  
  def new
    @position_name = PositionName.new
  end
  
  def create
    @position_name = PositionName.new(params[:position_name], as_role)
    if @position_name.save
      redirect_to_index
    else
      render :new
    end
  end
  
  def edit
    @position_name = find_position_name(params[:id])
  end
  
  def update
    @position_name = find_position_name(params[:id])
    if @position_name.update_attributes(params[:position_name], as_role)
      redirect_to_index
    else
      render :edit
    end
  end
  
  def destroy
    @position_name = find_position_name(params[:id])
    @position_name.destroy
    redirect_to_index
  end
  
private
  
  def find_position_name(id)
    PositionName.find(id)
  end
  
  def redirect_to_index
    redirect_to position_names_path
  end
  
  def namespace
    :admin
  end
end