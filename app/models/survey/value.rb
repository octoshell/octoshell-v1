class Survey::Value < ActiveRecord::Base
  attr_accessible :survey_field_id, :user_id, :value
end
