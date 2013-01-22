class Admin::ReportsController < Admin::ApplicationController
  before_filter { authorize! :manage, :reports }

  def index
    @reports = Report.available.page(params[:page])
    @subnamespace = :index
  end

  def show
    @report = get_report(params[:id])
    @reply = @report.replies.build
    @comment = @report.comments.build
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
    @reply = @report.replies.build(params[:report_reply], as: :admin)
    @reply.user = current_user
    if @reply.save
      redirect_to admin_report_path(@report, anchor: 'replies')
    else
      @comment = @report.comments.build
      render :show
    end
  end

  def comments
    @report = get_report(params[:report_id])
    @comment = @report.comments.build(params[:report_comment], as: :admin)
    @comment.user = current_user
    if @comment.save
      redirect_to admin_report_path(@report, anchor: 'comments')
    else
      @reply = @report.replies.build
      render :show
    end
  end

  def assess
    @report = get_report(params[:report_id])
    project = @report.projects.find(params[:project_id])
    project.assign_attributes(params[:report_project], as: :admin)
    if project.assessed? || project.assess
      redirect_to [:admin, @report]
    else
      render :show
    end
  end

  def decline
    @report = get_report(params[:report_id])
    @report.editing? || @report.decline
    redirect_to admin_reports_path, notice: t('.report_returned_to_user_for_edit')
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
