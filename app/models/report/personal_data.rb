class Report::PersonalData < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :middle_name  
end
