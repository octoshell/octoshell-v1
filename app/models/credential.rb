class Credential < ActiveRecord::Base
  attr_accessor :skip_creating_accesses
  
  include Models::Paranoid
  
  has_many :accesses
  belongs_to :user
  
  attr_accessible :public_key, :name
  attr_accessible :public_key, :name, :user_id, as: :admin
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
  
  after_create :give_accesses, unless: :skip_creating_accesses
  
  def grant_accesses
    return false if check_waiting?
    
    user.requests.active.each do |request|
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
  
  def close_accesses
    accesses.destroy_all
    true
  end
  
private
  
  def check_waiting
    if accesses.any? { |access| access.tasks.pending.exists? }
      errors.add(:base, :pending_tasks_present)
      false
    else
      true
    end
  end
end
