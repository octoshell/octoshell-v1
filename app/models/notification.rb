class Notification < ActiveRecord::Base
  include Models::Limitable
  has_paper_trail
  
  validates :title, :body, presence: true
  
  attr_accessible :title, :body, as: :admin
  
  has_many :recipients, dependent: :destroy
  
  state_machine initial: :pending do
    state :pending
    state :delivering
    state :delivered do
      validate do
        if recipients.with_state(:pending).any?
          errors.add(:base, "Не все письма разосланы")
        end
      end
    end
    
    event :deliver do
      transition :pending => :delivering
    end
    
    event :complete_delivering do
      transition :delivering => :delivered
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
    recipients.each do |rec|
      Delayed::Job.enqueue NotificationsSender.new(rec.id)
    end
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
  
  def add_unsuccessful_of_current_session
    if session = Session.current
      User.without_state(:closed).each do |u|
        has_unsubmitted_surveys = u.user_surveys.where(survey_id: session.survey_ids).without_state(:submitted).any?
        has_unassessed_reports = Report.where(session_id: session.id, project_id: u.owned_project_ids).any?
        if has_unsubmitted_surveys || has_unassessed_reports
          recipients.where(user_id: u.id).first_or_create!
        end
      end
    end
  end
end
