class Admin::OrganizationKindsController < Admin::ApplicationController
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = OrganizationKind.search(params[:search])
    @organization_kinds = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @organization_kind = find_organization_kind(params[:id])
  end
  
  def new
    @organization_kind = OrganizationKind.new
  end
  
  def create
    @organization_kind = OrganizationKind.new(params[:organization_kind], as_role)
    if @organization_kind.save
      redirect_to @organization_kind
    else
      render :new
    end
  end
  
  def edit
    @organization_kind = find_organization_kind(params[:id])
  end
  
  def update
    @organization_kind = find_organization_kind(params[:id])
    if @organization_kind.update_attributes(params[:organization_kind], as_role)
      redirect_to @organization_kind
    else
      render :edit
    end
  end
  
  def close
    @organization_kind = find_organization_kind(params[:organization_kind_id])
    @organization_kind.close
    redirect_to @organization_kind
  end
  
private
  
  def find_organization_kind(id)
    OrganizationKind.find(id)
  end

  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
