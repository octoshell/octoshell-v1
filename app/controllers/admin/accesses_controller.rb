class Admin::AccessesController < ApplicationController
  before_filter :require_login, :setup_default_filter
  before_filter { authorize! :manage, :accesses }

  def index
    @search = Access.search(params[:search])
    @accesses = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def new
    @access = Access.new
  end
  
  def create
    @access = Access.new(params[:access])
    if @access.save
      redirect_to @access
    else
      render :new
    end
  end
  
  def edit
    @access = Access.find(params[:id])
  end
  
  def update
    @access = Access.find(params[:id])
    if @access.update_attributes(params[:access])
      redirect_to @access
    else
      render :edit
    end
  end
  
private
  
  def namespace
    :admin
  end
 
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
