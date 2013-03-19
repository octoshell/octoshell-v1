class Admin::OrganizationKindsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = OrganizationKind.search(params[:q])
    @organization_kinds = show_all? ? @search.all : @search.result(distinct: true).page(params[:page])
  end
  
  def show
    @organization_kind = find_organization_kind(params[:id])
  end
  
  def new
    @organization_kind = OrganizationKind.new
  end
  
  def create
    @organization_kind = OrganizationKind.new(params[:organization_kind], as: :admin)
    if @organization_kind.save
      redirect_to [:admin, @organization_kind]
    else
      render :new
    end
  end
  
  def edit
    @organization_kind = find_organization_kind(params[:id])
  end
  
  def update
    @organization_kind = find_organization_kind(params[:id])
    if @organization_kind.update_attributes(params[:organization_kind], as: :admin)
      redirect_to [:admin, @organization_kind]
    else
      render :edit
    end
  end
  
  def close
    @organization_kind = find_organization_kind(params[:organization_kind_id])
    @organization_kind.close
    redirect_to [:admin, @organization_kind]
  end
  
private
  
  def find_organization_kind(id)
    OrganizationKind.find(id)
  end

  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end
end
