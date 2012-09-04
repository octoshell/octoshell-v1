# coding: utf-8
class Task < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  PROCEDURES = %w(
    add_user
    block_project
    unblock_project
    del_user
    add_openkey
    del_openkey
    add_project
    del_project
  )
  
  belongs_to :resource, polymorphic: true
  belongs_to :task
  has_many :tasks
  
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
    
    event :_resolve do
      transition failed: :successed
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
        # do it after commit !!!
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
  
  def family
    task ? task.tasks + [task] - [self] : (tasks.any? ? tasks : nil)
  end
  
  def retry(attributes, options = {})
    task = tasks.build(attributes, options)
    if task.save
      Resque.enqueue(TasksRequestsWorker, task.id)
      task
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
end
