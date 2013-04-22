class FaultsController < ApplicationController
  before_filter :require_login
  
  def show
    @fault = current_user.faults.find(params[:id])
    @reply = @fault.replies.build do |r|
      r.user = current_user
    end
  end
end
