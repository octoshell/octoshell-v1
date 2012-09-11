# Модель доступа человека к проекту
class Account < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :state_name, to: :user, prefix: true, allow_nil: true
  delegate :state_name, to: :project, prefix: true, allow_nil: true
  
  attr_accessor :raw_emails
  
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  has_many :cluster_users, autosave: true, dependent: :destroy
  
  validates :user, :project, presence: true
  validates :project_state_name, inclusion: { in: [:active] }, if: :active?
  validates :user_state_name, inclusion: { in: [:sured] }, if: :active?
  validates :user_state_name, exclusion: { in: [:closed] }, if: :active?
  validates :username, presence: true, on: :update
  validate :emails_validator, if: :raw_emails
  
  attr_accessible :project_id, :raw_emails
  attr_accessible :project_id, :raw_emails, :user_id, :username, as: :admin
  
  after_create :assign_username, :create_relations
  
  state_machine initial: :closed do
    state :closed
    state :requested
    state :active
    
    event :_request do
      transition closed: :requested
    end
    
    event :_activate do
      transition [:closed, :requested] => :active
    end
    
    event :_decline do
      transition requested: :closed
    end
    
    event :_cancel do
      transition active: :closed
    end
  end
  
  define_defaults_events :request, :activate, :decline, :cancel
  
  define_state_machine_scopes
  
  def activate
    if user.ready_to_activate_account?
      activate!
    else
      errors.add(:base, :not_ready_to_be_activated)
      false
    end
  end
  
  def activate!
    self.transaction do
      _activate!
      cluster_users.joins(:cluster_project).where(
        cluster_projects: { state: 'active' }
      ).includes(:cluster_project).each &:activate!
    end
  end
  
  def cancel!
    transaction do
      _cancel!
      cluster_users(true).non_closed.each &:close!
    end
  end
  
  # test it
  def send_invites
    emails_validator
    return if errors.any?
    
    UserMailer.invitation(self).deliver
  end
  
  # test it
  def invite
    return if invalid?
    
    transaction do
      save!
      activate
      true
    end
  end
  
  # test it
  def emails
    raw_emails.to_s.split(',').map &:strip
  end
  
  def accesses
    Access.where(
      credential_id:   user.credential_ids,
      cluster_user_id: cluster_user_ids
    )
  end
  
  def username=(username)
    self[:username] = username
    cluster_users.each { |cu| cu.username = username }
  end
  
private
  
  def emails_validator
    emails.each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        errors.add(:raw_emails, :invalid_email, email: email)
      end
    end
  end
  
  def assign_username
    username = 
      if project.cluster_user_type == 'account'
        "account_#{id}"
      else
        project.username
      end
    update_attribute :username, username
  end
  
  def create_relations
    project.cluster_projects(true).each do |cluster_project|
      conditions = { cluster_project_id: cluster_project.id }
      cluster_users.where(conditions).first_or_create!
    end
    true
  end
end
