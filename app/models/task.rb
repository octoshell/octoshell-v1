class Task < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  
  validates :resource, :stdin, presence: true
  
  attr_accessible :stdin
end
