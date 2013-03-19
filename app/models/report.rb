# coding: utf-8
class Report < ActiveRecord::Base
  delegate :user, to: :project
  belongs_to :session
  belongs_to :project
  belongs_to :expert, class_name: :User
  
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
    state :declined
    
    event :accept do
      transition [:pending, :declined] => :accepted
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
    
    event :decline do
      transition :assessing => :declined
    end
  end
  
  def link_name
    'открыть'
  end
  
  def human_name
    %{Отчет по проекту "#{project.name.truncate(20)}"}
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
end
