class MembershipsController < ApplicationController
  before_filter :require_login
  
  def new
    @membership = current_user.memberships.build
    @membership.build_default_positions
  end
  
  def create
    @membership = current_user.memberships.build(params[:membership])
    if @membership.save
      @membership.user.track! :create_membership, @membership, current_user
      redirect_to @membership
    else
      @membership.build_default_positions
      render :new
    end
  end
    
  def edit
    @membership = find_membership(params[:id])
    @membership.build_default_positions
  end
  
  def update
    @membership = find_membership(params[:id])
    if @membership.update_attributes(params[:membership], as_role)
      @membership.user.track! :update_membership, @membership, current_user
      redirect_to @membership
    else
      @membership.build_default_positions
      render :edit
    end
  end
  
  def close
    @membership = find_membership(params[:membership_id])
    @membership.close
    @membership.user.track! :close_membership, @membership, current_user
    redirect_to @membership
  end
  
private
  
  def find_membership(id)
    current_user.memberships.find(id)
  end
  
  def namespace
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
