class AdminsController < ApplicationController
  before_filter :require_login
  
  def show
  end
  
private
  
  def namespace
    :admin
  end
end
