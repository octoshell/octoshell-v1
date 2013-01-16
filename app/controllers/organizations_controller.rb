class OrganizationsController < ApplicationController
  respond_to :json
  
  def index
    @organizations = Organization.finder(params[:q])
    json = {
      records: @organizations.page(params[:page]).per(params[:per]),
      total: @organizations.count
    }
    respond_with(json)
  end

  def show
    @organization = Organization.find(params[:id])
    respond_with({ id: @organization.id, text: @organization.name })
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(params[:organization])
    if @organization.save
      redirect_to profile_path, notice: t('organization_has_been_created', default: 'Organization has been created')
    else
      render :new
    end
  end
end
