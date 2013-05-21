class Fault::Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :fault
  
  validates :message, :user, :fault, presence: true
  
  attr_accessible :message
  attr_accessible :message, as: :admin
end
