class AdminsController < ApplicationController
  before_filter :require_login
  
  def show
    redirect_to sureties_path
  end
  
private
  
  def namespace
    :admin
  end
end
