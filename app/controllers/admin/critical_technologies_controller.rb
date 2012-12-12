class Admin::CriticalTechnologiesController < Admin::ApplicationController
  before_filter { authorize! :manage, :critical_technologies }

  def index
    @critical_technologies = CriticalTechnology.all  
  end

  def new
    
  end

  def create
    
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    
  end
end
