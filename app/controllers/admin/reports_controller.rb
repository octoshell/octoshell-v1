class Admin::ReportsController < Admin::ApplicationController
  before_filter { authorize! :manage, :reports }

  def index
    @reports = Report.submitted.page(params[:page])
    @subnamespace = :index
  end

  def show
    @report = get_report(params[:id])
    @reply = @report.replies.build
  end

  def all
    @reports = Report.page(params[:page])
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
    @reports = Report.assessed.page(params[:page])
    @subnamespace = :assessed
    render :index
  end

  def replies
    @report = get_report(params[:report_id])
    @reply = @report.replies.build(params[:report_reply])
    @reply.user = current_user
    if @reply.save
      redirect_to admin_report_path(@report, anchor: 'replies')
    else
      render :show
    end
  end

private
  
  def get_report(id)
    report = Report.find(id)
    if !(report.expert == current_user || report.assessing? || report.assessed?)
      raise MayMay::Unauthorized
    end
    report
  end
end
