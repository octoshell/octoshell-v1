# coding: utf-8
class Admin::ReportsController < Admin::ApplicationController
  before_filter { authorize! :access, :reports }
  
  def index
    @search = Report.search(params[:q])
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
end
