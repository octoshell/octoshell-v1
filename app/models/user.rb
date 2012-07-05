class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  has_many :accounts
  has_many :credentials
  has_many :projects, :through => :accounts
  
  validates :first_name, :last_name, :email, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }
  validates :email, uniqueness: true
  
  def requests
    Request.joins(project: :accounts).where(accounts: { user_id: id })
  end
end
