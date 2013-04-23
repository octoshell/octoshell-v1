class Cluster < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  has_many :tickets
  has_many :cluster_fields
  has_many :requests
  
  validates :name, :host, presence: true
  
  attr_accessible :name, :host, :description, as: :admin
  
  state_machine initial: :active do
    state :closed
    
    event :close do
      transition :active => :closed
    end
  end
  
  def cluster
    self
  end

  def link_name
    name
  end
end
