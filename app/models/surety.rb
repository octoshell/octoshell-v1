# coding: utf-8
require 'rtf'
class Surety < ActiveRecord::Base
  include Models::RTF
  
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :user, :organization, :direction_of_sciences, :critical_technologies,
    to: :project, allow_nil: true
  
  belongs_to :project, inverse_of: :sureties
  has_many :tickets
  has_many :surety_members, inverse_of: :surety
  
  validates :boss_full_name, :boss_position, :project, presence: true
  validates :cpu_hours, :gpu_hours, :size, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :boss_full_name, :boss_position, :surety_members_attributes,
    :cpu_hours, :gpu_hours, :size, :project_id
  
  accepts_nested_attributes_for :surety_members
  
  state_machine initial: :pending do
    state :pending
    state :confirmed
    state :active
    state :declined
    state :closed
    
    event :confirm do
      transition :pending => :confirmed
    end
    
    event :unconfirm do
      transition :confirmed => :pending
    end
    
    event :activate do
      transition [:confirmed, :pending] => :active
    end
    
    event :decline do
      transition [:confirmed, :pending] => :declined
    end
    
    event :close do
      transition [:pending, :confirmed, :active, :declined] => :closed
    end
    
    inside_transition :on => [:acivate, :close], &:user_revalidate!
  end
  
  def user_revalidate!
    user.revalidate!
  end
  
  def load_scan(file)
    if file.blank?
      errors.add(:base, "Не приложен файл")
      return false
    end
    
    self.tickets.create! do |ticket|
      ticket.user = user
      ticket.subject = "Скан к поручительству ##{id}"
      ticket.url = "/admin/sureties/#{id}"
      ticket.ticket_question_id = Settings.surety_ticket_question_id
      ticket.message = "Скан в приложении"
      ticket.attachment = file
    end
  end

  def link_name
    I18n.t('.open', default: 'Open')
  end
end
