# coding: utf-8
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
  validates :public_key, uniqueness: { scope: [:state, :user_id] }, if: :active?
  validate :public_key_validator
  
  after_create :activate_accesses
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def assign_attributes(attributes, options = {})
    attributes[:public_key_file].present? and attributes.delete(:public_key)
    super(attributes, options)
  end
  
  def public_key_file=(file)
    self[:public_key] = file.read
  end
  
  def close!
    transaction do
      _close!
      accesses.non_closed.each &:close!
    end
  end

  def link_name
    name
  end

private
  
  def activate_accesses
    user.accounts.map(&:cluster_users).flatten.each do |cluster_user|
      accesses.where(cluster_user_id: cluster_user.id).first_or_create!
    end
    
    accesses.each { |a| a.cluster_user.check_process! }
    
    accesses.joins(:cluster_user).includes(:cluster_user).
      where(cluster_users: { state: 'active' }).each &:activate!
  end
  
  def public_key_validator
    if public_key =~ /private/i
      errors.add(:public_key, "Указан приватный ключ!")
    end
  end
end
