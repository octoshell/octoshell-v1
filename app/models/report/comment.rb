class Report::Comment < ActiveRecord::Base
  default_scope order('id asc')

  belongs_to :report
  belongs_to :user

  validates :report, :user, :message, presence: true
  
  attr_accessible :message, as: :admin
end
