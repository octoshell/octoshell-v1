class Admin::OrganizationsController < ApplicationController
  def index
    @organizations = Organization.order(:name)
  end
  
  def show
    @organization = find_organization(params[:id])
  end
  
  def edit
    @organization = find_organization(params[:id])
  end
  
  def update
    @organization = find_organization(params[:id])
    if @organization.update_attributes(params[:organization])
      redirect_to [:admin, @organization]
    else
      render :edit
    end
  end
  
private
  
  def find_organization(id)
    Organization.find(id)
  end
end
