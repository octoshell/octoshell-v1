class MembershipsController < ApplicationController
  def index
    @memberships = Membership.all
  end
  
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
  
  def show
    @membership = find_membership(params[:id])
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
    Membership.find(id)
  end
  
  def namespace
    (@membership && @membership.user_id != current_user.id) ? :dashboard : :profile
  end
end
