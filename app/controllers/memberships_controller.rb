class MembershipsController < ApplicationController
  def new
    @membership = current_user.memberships.build
    @membership.build_default_positions
  end
  
  def create
    @membership = current_user.memberships.build(params[:membership])
    if @membership.save
      redirect_to profile_path
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
    if @membership.update_attributes(params[:membership])
      redirect_to profile_path
    else
      @membership.build_default_positions
      render :edit
    end
  end
  
private
  
  def find_membership(id)
    current_user.memberships.find(id)
  end
end
