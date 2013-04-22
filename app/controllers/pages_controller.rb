class PagesController < ApplicationController
  def index
    @pages = Page.all.find_all { |p| p.publicized or may?(:show_all, :pages) }
  end
  
  def show
    @page = find_page(params[:id])
    authorize! :show_all, :pages unless @page.publicized
  end
  
private

  def namespace
    :pages
  end
  
  def find_page(id)
    Page.find_by_url!(id)
  end
end
