class PagesController < ApplicationController
  def index
    @pages = Page.all.find_all { |p| can?(:show, p) }
  end
  
  def new
    @page = Page.new
  end
  
  def show
    @page = find_page(params[:id])
    authorize! :show, @page
  rescue ActiveRecord::RecordNotFound
    if admin?
      @page = Page.new({ url: params[:id], name: params[:id].capitalize }, as_role)
      render :new
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def create
    @page = Page.new(params[:page], as_role)
    if @page.save
      redirect_to @page
    else
      render :new
    end
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page], as_role)
      redirect_to @page
    else
      render :edit
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to pages_path
  end
  
private
  
  def namespace
    :support
  end
  
  def find_page(id)
    Page.find_by_url!(id)
  end
end
