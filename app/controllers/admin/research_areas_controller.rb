class Admin::ResearchAreasController < Admin::ApplicationController
  before_filter { authorize! :manage, :research_areas }
  
  def index
    @research_areas = ResearchArea.all
  end
  
  def new
    @research_area = ResearchArea.new
  end
  
  def create
    @research_area = ResearchArea.new(params[:research_area], as: :admin)
    if @research_area.save
      redirect_to admin_research_areas_path
    else
      render :new
    end
  end
  
  def edit
    @research_area = ResearchArea.find(params[:id])
  end
  
  def update
    @research_area = ResearchArea.find(params[:id])
    if @research_area.update_attributes(params[:research_area], as: :admin)
      redirect_to admin_research_areas_path
    else
      render :edit
    end
  end
  
  def destroy
    @research_area = ResearchArea.find(params[:id])
    @research_area.destroy
    redirect_to admin_research_areas_path
  end
end
