class OrganizationsController < ApplicationController
  before_filter :require_login
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      redirect_to new_surety_path(organization_id: @organization.id)
    else
      render :new
    end
  end
end
