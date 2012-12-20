class Report::Organization < ActiveRecord::Base
  attr_accessible :name, :subdivision, :position
end
