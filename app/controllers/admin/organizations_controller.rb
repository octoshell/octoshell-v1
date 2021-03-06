class Admin::OrganizationsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def new
    @organization = Organization.new
  end
  
  def index
    respond_to do |format|
      format.html do
        @search = Organization.search(params[:q])
        search_result = @search.result(distinct: true).includes(:organization_kind, :city, :country)
        @organizations = show_all? ? search_result : search_result.page(params[:page])
      end
      format.json do
        @organizations = Organization.finder(params[:q])
        render json: { records: @organizations.page(params[:page]).per(params[:per]), total: @organizations.count }
      end
    end
  end
  
  def create
    @organization = Organization.new(params[:organization], as: :admin)
    if @organization.save
      current_user.track! :create_organization, @organization, current_user
      redirect_to [:admin, @organization]
    else
      render :new
    end
  end
  
  def show
    @organization = find_organization(params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @organization }
    end
  end

  def edit
    @organization = find_organization(params[:id])
  end

  def update
    @organization = find_organization(params[:id])
    if @organization.update_attributes(params[:organization], as: :admin)
      redirect_to [:admin, @organization]
    else
      render :edit
    end
  end
  
  def merge
    @organization = find_organization(params[:organization_id])
    @duplication = find_organization(params[:organization][:merge_id])
    if @organization.merge(@duplication)
      redirect_to [:admin, @organization]
    else
      render :show
    end
  end
  
  def close
    @organization = find_organization(params[:organization_id])
    @organization.close
    redirect_to [:admin, @organization]
  end
  
private
  
  def find_organization(id)
    Organization.find(id)
  end
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
    params[:q][:meta_sort] ||= 'name.asc'
  end
end
