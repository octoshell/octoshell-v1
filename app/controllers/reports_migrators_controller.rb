class ReportsMigratorsController < Admin::ApplicationController
  def show
    ids = OldReport.where(state: 'assessed')
    @report_project = OldReportProject.where(report_id: ids, project_id: nil).order('id').first
  end
  
  def update
    OldReportProject.where(id: params[:id]).update_all(project_id: params[:project_id])
    redirect_to reports_migrator_path
  end
end

class OldReport < ActiveRecord::Base
  def user
    User.find(user_id)
  end
end
class OldReportProject < ActiveRecord::Base
  def report
    OldReport.find(report_id)
  end
  
  def project
    Project.find(project_id)
  end
end
