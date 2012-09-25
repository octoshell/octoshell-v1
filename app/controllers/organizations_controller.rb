class OrganizationsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def new
    @organization = Organization.new
  end
  
  def index
    @search = Organization.search(params[:search])
    @organizations = @search.page(params[:page])
  end
  
  def create
    @organization = Organization.new(params[:organization], as_role)
    if @organization.save
      redirect_to admin? ? @organization : dashboard_path
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
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
