class ReportsController < ApplicationController
  before_filter :require_login

  def edit
    @report = get_report(params[:id])
    @report.personal_data.valid?(:update)
    @report.personal_survey.valid?(:update)
    @report.organizations.each { |o| o.valid?(:update) }
    @report.projects.each { |p| p.valid?(:update) }
  end

  def update
    @report = get_report(params[:id])
    @report.attributes = params[:report]
    if @report.save(validate: false)
      redirect_to [:edit, @report], notice: t('.reports_draft_saved')
    else
      render :edit
    end
  end

  def submit
    @report = get_report(params[:report_id])
    @report.attributes = params[:report]
    if @report.valid? && (@report.submitted? || @report.submit!)
      redirect_to root_path, notice: t('.report_submitted')
    else
      flash.now[:alert] = t('.cant_submit_report_because_of_errors')
      render :edit
    end
  end

private
  
  def get_report(id)
    current_user.reports.find(id)
  end
end
