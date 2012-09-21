class AccountFinder
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :user_id, :project_id
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  validates :project_id, :user_id, presence: true
  
  def find
    Account.where(project_id: project_id, user_id: user_id).first
  end
  
  def persisted?
    false
  end
end
