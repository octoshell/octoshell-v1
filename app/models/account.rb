class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  validates :user, :project, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
end
