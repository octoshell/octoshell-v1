class PagesController < ApplicationController
  def index
    @pages = Page.all.find_all { |p| may?(:show, p) }
  end
  
  def show
    @page = find_page(params[:id])
    authorize! :show_all, :pages unless @page.publicized
  end
  
private
  
  def find_page(id)
    Page.find_by_url!(id)
  end
end
