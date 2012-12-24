class ReportsController < ApplicationController
  before_filter :require_login

  def edit
    @report = current_user.reports.find(params[:id])
    @report.setup_defaults!
  end

  def update
    @report = current_user.reports.find(params[:id])
    if @report.update_attributes(params[:report])
      redirect_to [:edit, @report]
    else
      render :edit
    end
  end
end
