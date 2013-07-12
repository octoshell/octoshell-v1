class Admin::ExtendsController < Admin::ApplicationController
  def index
    @extends = Extend.order('id')
  end
  
  def new
    @extend = Extend.new
  end
  
  def create
    @extend = Extend.new(params[:extend], as: :admin)
    if @extend.save
      redirect_to admin_extends_path
    else
      render :new
    end
  end
  
  def edit
    @extend = Extend.find(params[:id])
  end
  
  def update
    @extend = Extend.find(params[:id])
    if @extend.update_attributes(params[:extend], as: :admin)
      redirect_to admin_extends_path
    else
      render :edit
    end
  end
  
  def destroy
    @extend = Extend.find(params[:id])
    @extend.destroy
    redirect_to admin_extends_path
  end
end
