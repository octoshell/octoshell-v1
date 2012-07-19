class AccessesController < ApplicationController
  before_filter :require_login
  
  def show
    @access = Access.find(params[:id])
  end
  
private
  
  def namespace
    :admin
  end
end
