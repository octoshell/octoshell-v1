class OldReportPersonalSurvey < ActiveRecord::Base
  serialize :software
  serialize :technologies
  serialize :compilators
  serialize :learning
  serialize :wanna_be_speaker
  serialize :request_technology
  serialize :computing
  serialize :precision
  
  def report
    Report.find(report_id)
  end
end