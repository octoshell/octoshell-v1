# Отчет о проекте
class Report < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  delegate :user, to: :project
  
  belongs_to :session
  belongs_to :project
  belongs_to :expert, class_name: :User
  has_many :replies, class_name: :"Report::Reply"
  
  has_attached_file :materials,
    content_type: ['application/zip', 'application/x-zip-compressed'],
    max_size: 20.megabytes
  
  attr_accessible :materials
  attr_accessible :illustration_points, :statement_points, :summary_points,
    as: :admin
  
  state_machine :state, initial: :pending do
    state :pending
    state :accepted
    state :submitted do
      validates :materials, attachment_presence: true
    end
    state :assessing
    state :assessed
    state :rejected
    
    event :accept do
      transition :pending => :accepted
    end
    
    event :submit do
      transition :accepted => :submitted
    end
    
    event :pick do
      transition :submitted => :assessing
    end
    
    event :assess do
      transition :assessing => :assessed
    end
    
    event :reject do
      transition :assessing => :rejected
    end
    
    event :edit do
      transition :assessed => :assessing
    end
    
    event :resubmit do
      transition :rejected => :assessing
    end
    
    inside_transition on: :assess, &:notify_about_assesses
    inside_transition on: :reject, &:notify_about_reject
    inside_transition on: :resubmit, &:notify_about_resubmit
  end
  
  def link_name
    'открыть'
  end
  
  def human_name
    %{Отчет по проекту "#{project.title.truncate(20)}"}
  end
  
  def bootstrap_status
    case state_name
    when :pending then
      :default
    when :accepted then
      :warning
    when :submitted, :assessing then
      :success
    when :assessed then
      :info
    end
  end
  
  def passed?
    ([illustration_points, statement_points, summary_points].all? do |p|
      p.to_i > 2
    end && assessed?) || assessing? || submitted?
  end
  
  def notify_about_reject
    Mailer.delay.report_rejected(self)
  end
  
  def notify_about_assesses
    Mailer.delay.report_assessed(self)
  end
  
  def notify_about_resubmit
    Mailer.delay.report_resubmitted(self)
  end
end
