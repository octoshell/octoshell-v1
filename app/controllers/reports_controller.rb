class ReportsController < ApplicationController
  before_filter :require_login
  
  def accept
    @report = get_report(params[:report_id])
    @report.accepted? || @report.accept!
    redirect_to @report
  end
  
  def show
    @report = get_report(params[:id])
  end
  
  def submit
    @report = get_report(params[:report_id])
    @report.assign_attributes(params[:report])
    if @report.submitted? || @report.submit
      redirect_to @report
    else
      render :show
    end
  end

private
  
  def get_report(id)
    current_user.reports.find(id)
  end
end
