class Account < ActiveRecord::Base
  belongs_to :user, inverse_of: :accounts
  belongs_to :project, inverse_of: :accounts
  
  validates :user, :project, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
end
