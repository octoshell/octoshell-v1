class Fault::Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :fault
  
  validates :message, :user, :fault, presence: true
  
  attr_accessible :message
  attr_accessible :message, as: :admin
  after_create :notify_users
  
  private
  def notify_users
    if user == fault.user
      Mailer.delay.fault_reply(user, self)
    else
      Group.faults_managers.users.each do |user|
        Mailer.delay.fault_reply(user, self)
      end
    end
  end
end
