class Admin::ReportsController < Admin::ApplicationController
  before_filter { authorize! :access, :reports }
  
  def index
    @search = Report.search(params[:q] || default_index_params)
    @reports = @search.result(distinct: true).page(params[:page])
  end
  
  def pick
    authorize! :assess, :reports
    @report = Report.find(params[:report_id])
    @picker = ReportPicker.new(current_user)
    if @picker.pick(@report)
      redirect_to [:admin, @report]
    else
      redirect_to admin_reports_path(q: { state_in: 'submitted' }),
        alert: @picker.error
    end
  end
  
  def assess
    authorize! :assess, :reports
    @report = Report.find(params[:report_id])
    @assesser = ReportAssesser.new(current_user)
    if @assesser.assess(@report, params[:report])
      redirect_to admin_reports_path
    else
      redirect_to [:admin, @report], alert: @assesser.error
    end
  end
  
  def show
    @report = Report.find(params[:id])
    add_breadcrumb "Проект", [:admin, @report.project]
    add_breadcrumb "Отчет по проекту"
    raise MayMay::Unauthorized unless may?(:review, :reports) || @report.expert
  end
  
  private
  def default_breadcrumb
    false
  end
  
  def default_index_params
    params = { state_in: ['submitted'] }
    if s = Session.current
      params[:session_id_eq] = s.id
    end
    params
  end
end
