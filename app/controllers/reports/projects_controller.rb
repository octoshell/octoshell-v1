class Reports::ProjectsController < ApplicationController
  before_filter :require_login
  
  def create
    @report = get_report(params[:report_id])
    @report.projects.create! if @report.editing?
    @report.attributes = params[:report]
    @form = 'projects_form'
    @reply = @report.replies.build
    render 'reports/edit'
  end

  def destroy
    @report = get_report(params[:report_id])
    @report.projects.find(params[:id]).destroy  if @report.editing?
    @report.attributes = params[:reports]
    @form = 'projects_form'
    @reply = @report.replies.build
    render 'reports/edit'
  end

private
  
  def get_report(id)
    current_user.reports.find(id)
  end
end
