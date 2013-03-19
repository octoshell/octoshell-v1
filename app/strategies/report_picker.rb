# coding: utf-8
class ReportPicker
  attr_reader :error
  
  def initialize(user)
    @user = user
  end
  
  def pick(report)
    if report.can_pick?
      report.expert = @user
      report.pick!
    else
      @error = 'Отчет уже взят другим экспертом'
    end
  end
end
