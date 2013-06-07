class Admin::PagesController < Admin::ApplicationController
  def index
    @pages = Page.all
  end
  
  def new
    @page = Page.new
  end
  
  def show
    @page = find_page(params[:id])
    authorize! :show_all, :pages unless @page.publicized
  rescue ActiveRecord::RecordNotFound
    if may? :manage, :pages
      @page = Page.new({ url: params[:id], name: params[:id].capitalize }, as: :admin)
      render :new
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def create
    @page = Page.new(params[:page], as: :admin)
    if @page.save
      redirect_to [:admin, @page]
    else
      render :new
    end
  end
  
  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page], as: :admin)
      redirect_to [:admin, @page]
    else
      render :edit
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    redirect_to admin_pages_path
  end
  
private
  
  def find_page(id)
    Page.find_by_url!(id)
  end
end
