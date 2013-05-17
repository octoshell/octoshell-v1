class OldReportProject < ActiveRecord::Base
  serialize :exclusive_usage
  serialize :strict_schedule
end
