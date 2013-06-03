class Notification < ActiveRecord::Base
  include Models::Limitable
  has_paper_trail
  
  validates :title, :body, presence: true
  
  attr_accessible :title, :body, as: :admin
  
  has_many :recipients, dependent: :destroy
  
  state_machine initial: :pending do
    state :pending
    state :delivering
    state :delivered
    
    event :deliver do
      transition :pending => :delivering
    end
    
    inside_transition on: :deliver, &:send_emails
  end
  
  def add_all_recipients
    transaction do
      User.without_state(:closed).each do |u|
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
  
  def add_from_cluster(id)
    User.without_state(:closed).each do |u|
      if u.all_projects.any? { |p| p.requests.where(cluster_id: id).with_state(:active).any? }
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
  
  def test_send(user)
    rec = Recipient.new do |r|
      r.user = user
      r.notification = self
    end
    Mailer.notification(rec).deliver!
  end
  
  def remove_all_recipients
    recipients.delete_all
  end
  
  def send_emails
    recipients.each &:send_email
  end
  
  def add_with_projects
    User.without_state(:closed).each do |u|
      if u.all_projects.with_state(:active).any?
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
  
  def add_with_accounts
    User.without_state(:closed).each do |u|
      if u.accounts.with_access_state(:allowed).any? { |a| a.project.requests.with_state(:active).any? }
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
  
  def add_with_refused_accounts
    User.without_state(:closed).each do |u|
      if u.all_projects.with_state(:active).any? { |p| p.requests.with_state(:blocked).any? }
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
  
  def add_from_session(id)
    session = Session.find(id)
    User.without_state(:closed).each do |u|
      has_fault_with_session = proc do |s|
        u.faults.where(kind: "survey", reference_id: u.user_surveys.where(survey_id: session.survey_ids).pluck(:id)).with_state(:actual).any? || 
          u.faults.with_state(:actual).where(kind: "report", reference_id: u.reports.where(session_id: session.id)).any?
      end
      if u.faults.with_state(:actual).any? && has_fault_with_session.call
        recipients.where(user_id: u.id).first_or_create!
      end
    end
  end
end
