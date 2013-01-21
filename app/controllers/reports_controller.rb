class ReportsController < ApplicationController
  before_filter :require_login
  before_filter :setup_form

   def personal
    @report = Report.find(params[:report_id])
    @report.validate_part = :personal
    if @report.update_attributes(params[:report])
      redirect_to edit_report_url(@report, step: 'survey')
    else
      @form = 'personal_form'
      render :edit
    end
  end

  def survey
    @report = Report.find(params[:report_id])
    @report.validate_part = :survey
    if @report.update_attributes(params[:report])
      redirect_to edit_report_url(@report, step: 'projects')
    else
      @form = 'survey_form'
      render :edit
    end
  end

  def projects
    @report = Report.find(params[:report_id])
    @report.validate_part = :projects
    if @report.update_attributes(params[:report])
      redirect_to edit_report_url(@report, step: 'projects_survey')
    else
      @form = 'projects_form'
      render :edit
    end
  end

  def projects_survey
    @report = Report.find(params[:report_id])
    @report.validate_part = :projects_survey
    if @report.update_attributes(params[:report])
      redirect_to edit_report_url(@report)
    else
      @form = 'projects_survey_form'
      render :edit
    end
  end

  def edit
    @report = get_report(params[:id])
    @report.personal_data.valid?(:update)
    @report.personal_survey.valid?(:update)
    @report.organizations.each { |o| o.valid?(:update) }
    @report.projects.each { |p| p.valid?(:update) }
  end

  def submit
    @report = get_report(params[:report_id])
    @report.attributes = params[:report]
    if @report.completely_valid? && (@report.submitted? || @report.submit!)
      redirect_to projects_path, notice: t('.report_submitted')
    else
      flash.now[:alert] = t('.cant_submit_report_because_of_errors')
      render :edit
    end
  end

private
  
  def get_report(id)
    current_user.reports.find(id)
  end

  def setup_form
    @form = ({
      'personal'        => 'personal_form',
      'survey'          => 'personal_survey_form',
      'projects'        => 'projects_form',
      'projects_survey' => 'projects_survey_form'
    }[params[:step]] || 'personal_form')
  end
end
