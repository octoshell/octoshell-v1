# coding: utf-8
require 'rtf'
class Surety < ActiveRecord::Base
  include Models::RTF
  
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :user, :direction_of_sciences, :critical_technologies,
    to: :project, allow_nil: true
  
  belongs_to :organization
  belongs_to :project, inverse_of: :sureties
  has_many :tickets
  has_many :surety_members, inverse_of: :surety
  has_many :users, through: :surety_members
  
  validates :project, :organization, presence: true
  validates :cpu_hours, :gpu_hours, :size, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :boss_full_name, :boss_position, :surety_members_attributes,
    :cpu_hours, :gpu_hours, :size, :project_id, :organization_id
  
  accepts_nested_attributes_for :surety_members
  
  state_machine initial: :filling do
    state :filling
    state :generated
    state :confirmed
    state :active
    state :closed
    
    event :generate do
      transition :filling => :generated
    end
    
    event :confirm do
      transition :generated => :confirmed
    end
    
    event :unconfirm do
      transition :confirmed => :generated
    end
    
    event :activate do
      transition [:confirmed, :generated] => :active
    end
    
    event :close do
      transition [:filling, :generated, :confirmed, :active, :declined] => :closed
    end
    
    inside_transition :on => [:activate, :close], &:revalidate_users!
  end
  
  def revalidate_users!
    users.each &:revalidate!
  end
  
  def has_loaded_scan?
    tickets.any?
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
