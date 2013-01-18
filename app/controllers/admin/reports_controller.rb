class Admin::ReportsController < Admin::ApplicationController
  def index
    @reports = Report.submitted
  end

  def show
    @report = Report.find(params[:id])
    if !(@report.expert == current_user || @report.assessing? || @report.assessed?)
      raise MayMay::Unauthorized
    end
  end

  def all
    @reports = Report.all
    @subnamespace = :all
    render :index
  end

  def begin_assessing
    @report = Report.find(params[:report_id])
    @report.expert = current_user
    if @report.assessing? or @report.begin_assessing
      redirect_to [:admin, @report]
    else
      redirect_to admin_reports_path
    end
  end

  def self_assessing
    @reports = current_user.assessing_reports
    @subnamespace = :self_assessing
    render :index
  end

  def assessed
    @reports = Report.rated
    @subnamespace = :assessed
    render :index
  end
end
