class OrganizationKindsController < ApplicationController
  def index
    @organization_kinds = OrganizationKind.scoped
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
  
  def namespace
    :admin
  end
end
