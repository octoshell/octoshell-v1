class Survey::Field < ActiveRecord::Base
  attr_accessible :collection, :collection_sql, :kind, :max_values, :survey_id
end
