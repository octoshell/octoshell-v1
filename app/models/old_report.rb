class OldReport < ActiveRecord::Base
  def projects
    OldReportProject.where(report_id: id)
  end
end
