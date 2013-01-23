class Report::Reply < ActiveRecord::Base
  default_scope order("id asc")
  
  belongs_to :report
  belongs_to :user
  
  attr_accessible :message
  attr_accessible :message, as: :admin

  after_create :notify, on: :create

  validates :message, :report, :user, presence: true

  def expert_name
    report.expert_name(user_id)
  end

private

  def notify
    users = report.replies.pluck(:user_id).uniq
    users.delete(user_id)
    User.find(users).each do |user|
      Mailer.report_reply(user, self).deliver
    end
  end
end
