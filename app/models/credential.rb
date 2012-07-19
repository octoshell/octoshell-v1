class Credential < ActiveRecord::Base
  has_many :accesses, dependent: :destroy
  belongs_to :user
  
  attr_accessible :public_key, :name
  attr_accessible :public_key, :name, :user_id, as: :admin
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
  
  after_create :create_accesses
  
private
  
  def create_accesses
    user.requests.joins(:cluster).active.each do |request|
      user.credentials.each do |credential|
        conditions = {
          project_id: request.project_id,
          cluster_id: request.cluster_id
        }
        accesses.where(conditions).first_or_create!
      end
    end
    true
  end
end
