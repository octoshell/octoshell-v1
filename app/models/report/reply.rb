class Report::Reply < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  attr_accessible :message

  validates :message, :report, :user, presence: true
end
