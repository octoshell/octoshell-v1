class Request < ActiveRecord::Base
  belongs_to :project, inverse_of: :requests
  belongs_to :cluster
  belongs_to :user
  
  validates :project, :cluster, :hours, :user, presence: true
  
  attr_accessible :hours, :cluster_id
  
  before_validation :assign_user, on: :create
  
protected
  
  def assign_user
    self.user ||= project.try(:user)
  end
end
