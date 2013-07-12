# Префикс проекта
class ProjectPrefix < ActiveRecord::Base
  delegate :to_s, to: :name
  
  attr_accessible :name, as: :admin
end
