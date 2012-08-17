# Модель доступа человека к проекту
# `activate` - активирует доступ к проекту если это возможно
# (есть подтверждение и место работы). Создает доступы к кластерам
# `close` - отменяет доступ к проекту. Пытается удалить доступы к кластерам
# `decline` - отказать в доступе к проекту
class Account < ActiveRecord::Base
  has_paper_trail
  
  delegate :state_name, to: :user, prefix: true, allow_nil: true
  delegate :state_name, to: :project, prefix: true, allow_nil: true
  
  attr_accessor :raw_emails
  
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  
  validates :user, :project, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
  validates :project_state_name, inclusion: { in: [:active] }, if: :active_or_pending?
  validates :user_state_name, inclusion: { in: [:sured] }, if: :active?
  validates :user_state_name, exclusion: { in: [:closed] }, if: :active?
  validate :emails_validator, if: :raw_emails
  
  attr_accessible :project_id, :raw_emails
  attr_accessible :project_id, :raw_emails, :user_id, as: :admin
  
  state_machine initial: :pending do
    state :pending
    state :active
    state :declined
    state :closed
    
    event :_activate do
      transition any => :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :decline, :close
  
  define_state_machine_scopes
  
  # активирует аккаунт
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
      user.credentials.each do |credential|
        project.cluster_users.each do |cluster_user|
          conditions = {
            cluster_user_id: cluster_user.id,
            credential_id:   credential.id
          }
          Access.non_closed.where(conditions).first_or_create!
        end
      end
    end
  end
  
  def close!
    transaction do
      _close!
      accesses.non_closed.each &:close!
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
      cluster_user_id: project.cluster_user_ids
    )
  end
  
  def active_or_pending?
    active? || pending?
  end
  
private
  
  def emails_validator
    emails.each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        errors.add(:raw_emails, :invalid_email, email: email)
      end
    end
  end
end
