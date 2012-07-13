module Admin
  class PositionNamesController < BaseController
    def index
      @position_names = PositionName.all
    end
    
    def new
      @position_name = PositionName.new
    end
    
    def create
      @position_name = PositionName.new(params[:position_name])
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
      if @position_name.update_attributes(params[:position_name])
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
      redirect_to [:admin, :position_names]
    end
  end
end