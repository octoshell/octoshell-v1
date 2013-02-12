# coding: utf-8
class Admin::ReportsController < Admin::ApplicationController
  before_filter { authorize! :access, :reports }

  def index
    @reports = show_all? ? Report.available : Report.available.page(params[:page])
    @subnamespace = :index
  end

  def show
    authorize! :manage, :reports
    @report = get_report(params[:id])
    @reply = @report.replies.build
    @ticket = @report.build_support_ticket
  end

  def all
    @reports = show_all? ? Report.all : Report.page(params[:page])
    @subnamespace = :all
    render :index
  end

  def begin_assessing
    authorize! :manage, :reports
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
    @reports = show_all? ? Report.assessed : Report.assessed.page(params[:page])
    @subnamespace = :assessed
    render :index
  end
  
  def latecommers
    @reports = Report.latecommers.with_state(:submitted)
    @reports = @reports.page(params[:page]) if show_all?
    @subnamespace = :latecommers
    render :index
  end

  def replies
    authorize! :manage, :reports
    @report = get_report(params[:report_id])
    @reply = @report.replies.build(params[:report_reply], as: :admin)
    @reply.user = current_user
    if @reply.save
      redirect_to admin_report_path(@report, anchor: 'replies')
    else
      @ticket = @report.build_support_ticket
      render :show
    end
  end

  def assess
    authorize! :manage, :reports
    @report = get_report(params[:report_id])
    if @report.assessed? || @report.assess
      redirect_to admin_reports_path, notice: t('.report_successfuly_assessed')
    else
      render :show
    end
  end

  def decline
    authorize! :manage, :reports
    @report = get_report(params[:report_id])
    @report.editing? || @report.decline
    redirect_to [:admin, @report], notice: t('.report_returned_to_user_for_edit')
  end

  def review
    authorize! :review, :reports
    @report = Report.find(params[:report_id])
  end
  
  def ticket
    authorize! :manage, :reports
    @report = get_report(params[:report_id])
    @ticket = @report.build_support_ticket(params[:ticket])
    if @ticket.save
      redirect_to @ticket
    else
      @reply = @report.replies.build
      render :show
    end
  end
  
  def supervise
    authorize! :supervise, :reports
    @report = Report.find(params[:report_id])
  end
  
  def allow
    authorize! :supervise, :reports
    @report = Report.find(params[:report_id])
    @report.assign_attributes(params[:report], as: :admin)
    if @report.choose_allow_state
      redirect_to admin_reports_path
    else
      render :supervise
    end
  end
  
  def submit
    authorize! :manage, :reports
    @report = get_report(params[:report_id])
    if @report.submit
      redirect_to [:admin, @report], notice: 'Отчет отправлен на оценку'
    else
      redirect_to [:admin, @report], alert: 'Невозможно отправить отчет на оценку'
    end
  end
  
  def stats
    authorize! :manage, :reports
    @stats = Report::Stats.new
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
