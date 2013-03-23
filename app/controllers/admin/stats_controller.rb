class Admin::StatsController < Admin::ApplicationController
  def new
    @stat = Stat.new({ session_id: params[:session_id] }, as: :admin)
  end
  
  def create
    @stat = Stat.new(params[:stat], as: :admin)
    if @stat.save
      redirect_to [:admin, @stat.session]
    else
      render :new
    end
  end
  
  def edit
    @stat = Stat.find(params[:id])
  end
  
  def update
    @stat = Stat.find(params[:id])
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
