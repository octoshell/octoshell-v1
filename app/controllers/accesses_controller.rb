class AccessesController < ApplicationController
  before_filter :require_login
  before_filter :setup_default_filter, only: :index
  
  def index
    @search = Access.search(params[:search])
    @accesses = show_all? ? @search.all : @search.page(params[:page])
  end
  
  def show
    @access = Access.find(params[:id])
  end
  
private
  
  def namespace
    :admin
  end
  
  def setup_default_filter
    params[:search] ||= { state_in: ['active'] }
  end
end
