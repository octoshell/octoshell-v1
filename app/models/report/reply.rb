class Report::Reply < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  validates :report, :user, :message, presence: true
  
  attr_accessible :message
  attr_accessible :message, as: :admin
end
