class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  has_many :accounts
  has_many :credentials
  has_many :requests
  has_many :projects
  belongs_to :institute
  
  validates :first_name, :last_name, :email, :institute, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }
  validates :email, uniqueness: true
  
  def all_requests
    Request.joins(project: :accounts).where(accounts: { user_id: id })
  end
end
