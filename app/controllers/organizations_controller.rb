class OrganizationsController < ApplicationController
  before_filter :require_login
  
  def new
    @organization = Organization.new
  end
  
  def index
    @organizations = Organization.order(:name)
  end
  
  def create
    @organization = Organization.new(params[:organization], as_role)
    if @organization.save
      redirect_to @organization
    else
      render :new
    end
  end
  
  def show
    @organization = find_organization(params[:id])
  end

  def edit
    @organization = find_organization(params[:id])
  end

  def update
    @organization = find_organization(params[:id])
    if @organization.update_attributes(params[:organization], as_role)
      redirect_to @organization
    else
      render :edit
    end
  end
  
  def merge
    @organization = find_organization(params[:organization_id])
    @duplication = find_organization(params[:organization][:merge_id])
    if @organization.merge(@duplication)
      redirect_to @organization
    else
      render :show
    end
  end
  
  def close
    @organization = find_organization(params[:organization_id])
    @organization.close
    redirect_to @organization
  end
  
private
  
  def find_organization(id)
    Organization.find(id)
  end
  
  def namespace
    admin? ? :admin : :dashboard
  end
end
