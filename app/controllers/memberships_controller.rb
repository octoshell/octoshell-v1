class MembershipsController < ApplicationController
  before_filter :require_login
  
  def new
    add_breadcrumb 'Профиль', profile_path
    @membership = current_user.memberships.build do |m|
      if hash = params.delete(:membership)
        add_breadcrumb 'Новое место работы', new_membership_path
        add_breadcrumb 'Дополнительная информация'
        m.organization = Organization.find(hash[:organization_id])
      end
    end
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

  def show
    @membership = current_user.memberships.find(params[:id])
  end
    
  def edit
    @membership = find_membership(params[:id])
    @membership.build_default_positions
  end
  
  def update
    @membership = find_membership(params[:id])
    if @membership.update_attributes(params[:membership])
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
  
  def setup_default_filter
    params[:q] ||= { state_in: ['active'] }
  end
end
