class MembershipsController < ApplicationController
  before_filter :require_login
  
  def index
    if admin?
      @memberships = Membership.all
    else
      @memberships = current_user.memberships
    end
  end
  
  def new
    @membership = Membership.new
    @membership.user = current_user unless admin?
    @membership.build_default_positions
  end
  
  def create
    @membership = Membership.new(params[:membership], as_role)
    @membership.user = current_user unless admin?
    if @membership.save
      redirect_to @membership
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
    authorize! :edit, @membership
    @membership.build_default_positions
  end
  
  def update
    @membership = find_membership(params[:id])
    authorize! :update, @membership
    if @membership.update_attributes(params[:membership], as_role)
      redirect_to @membership
    else
      @membership.build_default_positions
      render :edit
    end
  end
  
  def close
    @membership = find_membership(params[:membership_id])
    authorize! :close, @membership
    @membership.close
    redirect_to @membership
  end
  
private
  
  def find_membership(id)
    Membership.find(id)
  end
  
  def namespace
    if admin?
      :admin
    else
      (@membership && @membership.user_id != current_user.id) ? :dashboard : :profile
    end
  end
end
