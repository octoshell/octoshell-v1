class Admin::StatsController < Admin::ApplicationController
  def new
    @session = Session.find(params[:session_id])
    @stat = @session.stats.build
  end
  
  def create
    @session = Session.find(params[:session_id])
    @stat = @session.stats.build(params[:stat], as: :admin)
    if @stat.save
      redirect_to [:admin, @session]
    else
      render :new
    end
  end
  
  def edit
    @session = Session.find(params[:session_id])
    @stat = @session.stats.find(params[:id])
  end
  
  def update
    @session = Session.find(params[:session_id])
    @stat = @session.stats.find(params[:id])
    if @stat.update_attributes(params[:stat], as: :admin)
      redirect_to [:admin, @stat.session]
    else
      render :edit
    end
  end
  
  def destroy
    @stat = Stat.find(params[:id])
    @stat.destroy
    redirect_to [:admin, @stat.session]
  end
end
