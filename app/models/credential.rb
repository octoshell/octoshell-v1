class Credential < ActiveRecord::Base
  attr_accessor :skip_creating_accesses
  
  include Models::Paranoid
  
  has_many :accesses
  belongs_to :user
  
  attr_accessible :public_key, :name
  attr_accessible :public_key, :name, :user_id, as: :admin
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
  
  after_create :grant_accesses, unless: :skip_creating_accesses
  
  state_machine initial: :active do
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  def close!
    transaction do
      _close!
      accesses.each &:close!
    end
  end
  
  def grant_accesses
    transaction do
      user.requests.active.each do |request|
        user.credentials.each do |credential|
          conditions = {
            project_id: request.project_id,
            cluster_id: request.cluster_id
          }
          accesses.where(conditions).first_or_create!
        end
      end
    end
  end
end
