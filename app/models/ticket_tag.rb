# coding: utf-8
class TicketTag < ActiveRecord::Base
  include Models::Limitable
  
  attr_accessor :merge_id
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :ticket_tag_relations, dependent: :destroy
  has_many :tickets, through: :ticket_tag_relations
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :ticket_questions
  
  validates :name, presence: true
  
  attr_accessible :name, :group_ids, as: :admin
  
  after_create :create_ticket_tag_relations
  scope :not_system, where(system: false)
  
  state_machine :state, initial: :active do
    state :active
    state :closed do
      validate do
        if system?
          errors.add(:base, :impossible_to_close_system_ticket)
        end
      end
    end
    
    event :close do
      transition active: :closed
    end
  end
  
  define_state_machine_scopes
  
  class << self
    def pending_surety
      special(:pending_surety)
    end
    
    def failed_task
      special(:failed_task)
    end
    
    def surety_scan
      special(:surety_scan)
    end
    
    def support
      special(:support)
    end
    
    def special(code)
      find_or_create_by_code!(code) do |t|
        t.name = code
        t.system = true
      end
    end
    private :special
  end
  
  def merge(tag)
    return false if self == tag
    
    transaction do
      active_ticket_ids = tag.ticket_tag_relations.active.pluck(:ticket_id)
      ticket_tag_relations.where(ticket_id: active_ticket_ids).
        update_all(active: true)
      tag.destroy
    end
  end

  def link_name
    name
  end
  
private
  
  def create_ticket_tag_relations
    Ticket.all.each do |ticket|
      ticket_tag_relations.create! do |relation|
        relation.ticket = ticket
      end
    end
  end
end
