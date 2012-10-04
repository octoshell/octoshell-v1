class MembershipsController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    if admin?
      @search = Membership.search(params[:search])
      @memberships = @search.page(params[:page])
    else
      @search = current_user.memberships.search(params[:search])
      @memberships = @search.page(params[:page])
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
    admin? ? :admin : :dashboard
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
