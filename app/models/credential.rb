# coding: utf-8
class Credential < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  attr_reader :public_key_file
  
  has_many :accesses
  belongs_to :user
  
  attr_accessible :public_key, :name, :public_key_file
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: [:state, :user_id] }, if: :active?
  validate :public_key_validator
  
  after_create :maintain_requests!
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :close do
      transition :active => :closed
    end
    
    inside_transition :on => :close, &:maintain_requests!
  end
  
  def assign_attributes(attributes, options = {})
    attributes[:public_key_file].present? and attributes.delete(:public_key)
    super(attributes, options)
  end
  
  def public_key_file=(file)
    self[:public_key] = file.read
  end

  def link_name
    name
  end
  
  def public_key_validator
    if public_key =~ /private/i
      errors.add(:public_key, "Указан приватный ключ!")
    end
  end
  
  def maintain_requests!
    user.accounts.with_cluster_state(:active).each do |account|
      account.project.requests.with_state(:active, :blocked).each do |r|
        r.request_maintain!
      end
    end
  end
end
