class ReportAssesser
  attr_reader :error
  
  def initialize(current_user)
    @user = current_user
  end
  
  def assess(report, attributes)
    if @user == report.expert
      report.assign_attributes(attributes, as: :admin)
      report.assess!
    else
      raise MayMay::Unauthorized
    end
  end
end
