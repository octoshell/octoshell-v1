class OldReport < ActiveRecord::Base
  def projects
    OldReportProject.where(report_id: id)
  end
  
  def user
    User.find(user_id)
  end
  
  def personal_survey
    OldReportPersonalSurvey.where(report_id: id).first
  end
end
