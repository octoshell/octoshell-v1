class VersionsController < ApplicationController
  def index
    @versions = resource.versions
  end
  
  def show
    @versions = resource.versions.find(params[:id])
  end
  
private
  
  def model
    params[:resource].constantize
  end
  helper_method :model
  
  def resource
    model.find(params["#{model.model_name.underscore}_id"])
  end
  
  def namespace
    :admin
  end
end
