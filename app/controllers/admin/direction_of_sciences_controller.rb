class Admin::DirectionOfSciencesController < Admin::ApplicationController
  before_filter { authorize! :manage, :direction_of_sciences }

  def index
    @direction_of_sciences = DirectionOfScience.order(:name)
  end

  def new
    @direction_of_science = DirectionOfScience.new
  end

  def create
    @direction_of_science = DirectionOfScience.new(params[:direction_of_science], as: :admin)
    if @direction_of_science.save
      redirect_to admin_direction_of_sciences_path
    else
      render :new
    end
  end

  def edit
    @direction_of_science = DirectionOfScience.find(params[:id])
  end

  def update
    @direction_of_science = DirectionOfScience.find(params[:id])
    if @direction_of_science.update_attributes(params[:direction_of_science], as: :admin)
      redirect_to admin_direction_of_sciences_path
    else
      render :edit
    end
  end

  def destroy
    @direction_of_science = DirectionOfScience.find(params[:id])
    @direction_of_science.destroy
    redirect_to admin_direction_of_sciences_path
  end
end
