class Admin::CriticalTechnologiesController < Admin::ApplicationController
  before_filter { authorize! :manage, :critical_technologies }

  def index
    @critical_technologies = CriticalTechnology.order(:name)
  end

  def new
    @critical_technology = CriticalTechnology.new
  end

  def create
    @critical_technology = CriticalTechnology.new(params[:critical_technology], as: :admin)
    if @critical_technology.save
      redirect_to admin_critical_technologies_path
    else
      render :new
    end
  end

  def edit
    @critical_technology = CriticalTechnology.find(params[:id])
  end

  def update
    @critical_technology = CriticalTechnology.find(params[:id])
    if @critical_technology.update_attributes(params[:critical_technology], as: :admin)
      redirect_to admin_critical_technologies_path
    else
      render :edit
    end
  end

  def destroy
    @critical_technology = CriticalTechnology.find(params[:id])
    @critical_technology.destroy
    redirect_to admin_critical_technologies_path
  end
end
