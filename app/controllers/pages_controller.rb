class PagesController < ApplicationController
  def index
    @pages = Page.all
  end
  
  def new
    @page = Page.new
  end
  
  def show
    @page = find_page(params[:id])
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
    @page = find_page(params[:id])
  end
  
  def update
    @page = find_page(params[:id])
    if @page.update_attributes(params[:page], as_role)
      redirect_to @page
    else
      render :edit
    end
  end
  
private
  
  def namespace
    :support
  end
  
  def find_page(id)
    Page.find_by_url!(id)
  end
end
