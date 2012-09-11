class Cluster < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :tickets
  has_many :cluster_fields
  has_many :cluster_projects
  
  validates :name, :host, presence: true
  
  attr_accessible :name, :host, :description, as: :admin
  
  after_create :create_relations
  
  state_machine initial: :active do
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      cluster_projects.non_closed.map(&:requests).flatten.each &:close!
    end
  end
  
  def cluster
    self
  end
  
  def requests
    Request.where(cluster_project_id: cluster_project_ids)
  end
  
private
  
  def create_relations
    Project.all.each do |project|
      cluster_projects.where(project_id: project.id).first_or_create!
    end
  end
end
