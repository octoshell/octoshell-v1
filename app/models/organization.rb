class Organization < ActiveRecord::Base
  has_paper_trail
  
  attr_accessor :merge_id
  
  has_many :sureties
  has_many :projects
  has_many :users, through: :sureties
  has_many :memberships
  belongs_to :organization_kind
  
  validates :name, presence: true, uniqueness: { scope: :organization_kind_id }
  validates :organization_kind, presence: true
  
  attr_accessible :name, :organization_kind_id
  
  after_create :notify_admins
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  define_state_machine_scopes
  
  def close!
    transaction do
      _close!
      sureties.each do |surety|
        surety.close!(I18n.t 'surety.comments.organization_deleted')
      end
    end
  end
  
  def surety_name
    name
  end
  
  def merge(organization)
    return if self == organization
    transaction do
      organization.sureties.update_all(organization_id: id)
      organization.memberships.update_all(organization_id: id)
      organization.destroy
    end
  end
  
  def kind
    organization_kind.name
  end
  
private
  
  def notify_admins
    UserMailer.notify_new_organization(self).deliver if User.admins.exists?
    true
  end
end
