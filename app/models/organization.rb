# coding: utf-8
class Organization < ActiveRecord::Base
  include Models::Paranoid
  
  attr_accessor :merge_id
  
  KINDS = %w(ВУС РАН)
  
  has_many :sureties
  has_many :users, through: :sureties
  has_many :memberships
  
  validates :name, presence: true, uniqueness: { scope: :kind }
  validates :kind, presence: true
  validates :kind, inclusion: { in: KINDS }
  
  attr_accessible :name, :kind
  
  after_create :notify_admins
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  
  def close!
    transaction do
      _close!
      sureties.each do |surety|
        surety.cancel!(I18n.t 'surety.comments.organization_deleted')
      end
    end
  end
  
  # before_destroy do
  #   sureties.each do |surety|
  #     if surety.pending?
  #       surety.comment = 
  #       surety.decline!
  #     elsif surety.active?
  #       surety.comment = I18n.t('surety.comments.organization_deleted')
  #       surety.cancel!
  #     end
  #   end
  # end
  
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
  
private
  
  def notify_admins
    UserMailer.notify_new_organization(self).deliver if User.admins.exists?
    true
  end
end
