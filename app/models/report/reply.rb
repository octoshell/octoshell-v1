class Report::Reply < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  attr_accessible :message, as: :admin

  validates :message, :report, :user, presence: true

  def expert_name
    report.expert_name(user_id)
  end
end
