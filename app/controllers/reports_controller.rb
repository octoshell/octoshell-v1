class ReportsController < ApplicationController
  before_filter :require_login
  
  def accept
    @report = get_report(params[:report_id])
    @report.accepted? || @report.accept!
    redirect_to report_path(@report, anchor: "start-page")
  end
  
  def show
    @report = get_report(params[:id])
    @reply = @report.replies.build do |reply|
      reply.user = current_user
    end
  end
  
  def replies
    @report = get_report(params[:report_id])
    @reply = @report.replies.build(params[:report_reply]) do |reply|
      reply.user = current_user
    end
    @reply.save
    redirect_to report_path(@report, anchor: "start-page")
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
  
  def resubmit
    @report = get_report(params[:report_id])
    @report.assign_attributes(params[:report])
    if @report.assessing? || @report.resubmit
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
