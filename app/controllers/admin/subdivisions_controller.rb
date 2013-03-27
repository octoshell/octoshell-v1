class Admin::SubdivisionsController < Admin::ApplicationController
  def index
    @organization = Organization.find(params[:organization_id])
    @subdivisions = get_subdivisions(params[:organization_id])
  end
  
  def new
    @organization = get_organization(params[:organization_id])
    @subdivision = @organization.subdivisions.build
  end
  
  def create
    @organization = get_organization(params[:organization_id])
    @subdivision = @organization.subdivisions.build(params[:subdivision], as: :admin)
    if @subdivision.save
      redirect_to admin_organization_subdivisions_path
    else
      render :new
    end
  end
  
  def edit
    @organization = get_organization(params[:organization_id])
    @subdivision = @organization.subdivisions.find(params[:id])
  end
  
  def update
    @organization = get_organization(params[:organization_id])
    @subdivision = @organization.subdivisions.find(params[:id])
    if @subdivision.update_attributes(params[:subdivision], as: :admin)
      redirect_to admin_organization_subdivisions_path
    else
      render :edit
    end
  end
  
  def merge
    @organization = get_organization(params[:organization_id])
    @subdivision = @organization.subdivisions.find(params[:subdivision_id])
    @merge = @organization.subdivisions.find(params[:subdivision][:merge_id])
    @subdivision.merge(@merge)
    redirect_to [:edit, :admin, @organization, @subdivision]
  end
  
  def destroy
    @organization = get_organization(params[:organization_id])
    @subdivision = @organization.subdivision.find(params[:id])
    @subdivision.destroy
    redirect_to admin_organization_subdivisions_path
  end
  
private

  def get_organization(id)
    Organization.find(id)
  end
  
  def get_subdivisions(id)
    get_organization(id).subdivisions
  end
end
