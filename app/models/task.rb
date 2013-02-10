# coding: utf-8
class Task < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  PROCEDURES = %w(
    add_user
    del_user
    add_openkey
    del_openkey
    add_project
    del_project
    block_project
    unblock_project
  )
  
  belongs_to :resource, polymorphic: true
  has_many :tickets, as: :resource
  
  validates :resource, :procedure, presence: true
  validates :procedure_string, inclusion: { in: PROCEDURES }
  
  attr_accessible :procedure, :resource_type, :resource_id, as: :admin
  
  PROCEDURES.each do |proc|
    scope proc.to_sym, where(procedure: proc)
    
    define_method "#{proc}?" do
      procedure == proc
    end
  end
  
  state_machine initial: :pending do
    state :successed
    state :failed
    state :pending
    event :_retry do
      transition [:successed, :failed] => :pending
    end
    event :_resolve do
      transition [:pending, :failed] => :successed
    end
  end
  
  define_defaults_events :resolve
  define_state_machine_scopes
  
  class << self
    def setup(procedure)
      transaction do
        task = scoped.create! do |task|
          task.procedure = procedure
        end
        Resque.enqueue TasksRequestsWorker, task.id
        task
      end
    end

    def human_resource_types
      @human_resource_types ||= 
        unscoped.select(:resource_type).uniq.map(&:resource_type).map do |klass|
          [klass.constantize.model_name.human, klass]
        end
    end
  end
  
  def retry
    if can__retry?
      _retry!
      Resque.enqueue(TasksRequestsWorker, id)
    else
      false
    end
  end
  
  def procedure_string
    procedure.to_s
  end
  
  def can_perform_callbacks?
    not callbacks_performed?
  end
  
  def perform_callbacks!
    return true unless can_perform_callbacks?
    
    transaction do
      resource.continue!(procedure, self)
      update_attribute :callbacks_performed, true
    end
  rescue StateMachine::InvalidTransition => e
    errors.add(:base, e.to_s)
    false
  rescue => e
    errors.add(:base, e.to_s)
    false
  end
  
  def description
    I18n.t("tasks.description.#{procedure}.html").html_safe
  end

  def link_name
    "Task #{id}"
  end
  
  def create_failure_ticket!
    Ticket.create! do |ticket|
      ticket.resource = self
      ticket.subject = "Процедура ##{id} выполнилась с ошибкой"
      ticket.url = "/admin/tasks/#{id}"
      ticket.role = :failed_task
      ticket.message = "Ошибка"
    end
  end
end
