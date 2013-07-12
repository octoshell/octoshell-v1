# Модель публичного ключа пользователя
class Credential < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  attr_reader :public_key_file
  
  has_many :accesses
  belongs_to :user
  
  attr_accessible :public_key, :name, :public_key_file
  
  validates :user, :public_key, :name, presence: true
  validates :public_key, uniqueness: { scope: [:user_id] }
  validate :public_key_validator
  
  after_create :maintain_requests!
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :activate do
      transition :closed => :active
    end
    
    event :close do
      transition :active => :closed
    end
    
    inside_transition :on => [:close, :activate], &:maintain_requests!
  end
  
  def activate_or_create
    if c = user.credentials.find_by_public_key(public_key)
      c.active? || c.activate!
    else
      save
    end
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
    unless OpenSSHKeyChecker.new(public_key).valid?
      errors.add(:public_key, "Не правильный ключ")
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
