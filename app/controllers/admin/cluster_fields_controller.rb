class Admin::ClusterFieldsController < ApplicationController
  before_filter { authorize! :manage, :cluster_fields }
  
  def create
    @cluster_field = ClusterField.new(params[:cluster_field])
    @cluster_field.save
    redirect_to_edit_page @cluster_field
  end
  
  def update
    @cluster_field = ClusterField.find(params[:id])
    @cluster_field.update_attributes(params[:cluster_field])
    redirect_to_edit_page(@cluster_field)
  end
  
  def destroy
    @cluster_field = ClusterField.find(params[:id])
    @cluster_field.destroy
    redirect_to_edit_page(@cluster_field)
  end

private
  
  def redirect_to_edit_page(cluster_field)
    if cluster_field.errors.any?
      redirect_to [:edit, cluster_field.cluster], alert: cluster_field.errors.full_messages.join(', ')
    else
      redirect_to [:edit, cluster_field.cluster]
    end
  end
end
