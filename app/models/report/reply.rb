# Ответ на отчет
class Report::Reply < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  validates :report, :user, :message, presence: true
  
  after_create :notify_user
  
  attr_accessible :message
  attr_accessible :message, as: :admin
  
  def notify_user
    ([report.user] + report.replies.map(&:user)).uniq.each do |u|
      Mailer.delay.report_reply(u, self)
    end
  end
end
