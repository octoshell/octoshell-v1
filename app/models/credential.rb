class Credential < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  attr_reader :public_key_file
  attr_accessor :skip_creating_accesses
  
  has_many :accesses
  belongs_to :user
  
  attr_accessible :public_key, :name, :public_key_file
  attr_accessible :public_key, :name, :user_id, :public_key_file, as: :admin
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: :user_id }
  
  after_create :grant_accesses, unless: :skip_creating_accesses
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def public_key_file=(file)
    self[:public_key] = file.read
  end
  
  def close!
    transaction do
      _close!
      accesses.each &:close!
    end
  end
  
  def grant_accesses
    transaction do
      user.requests.active.each do |request|
        request.project.cluster_users.each do |cluster_user|
          conditions = { cluster_user_id: cluster_user.id }
          accesses.where(conditions).first_or_create!
        end
      end
    end
  end
end
