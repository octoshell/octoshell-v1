class Organization < ActiveRecord::Base
  has_paper_trail
  
  delegate :state_name, to: :organization_kind, prefix: true, allow_nil: true
  
  attr_accessor :merge_id
  
  has_many :projects
  has_many :users, through: :sureties
  has_many :memberships
  has_and_belongs_to_many :coprojects, class_name: :Project
  belongs_to :organization_kind
  
  validates :name, presence: true, uniqueness: { scope: :organization_kind_id }
  validates :organization_kind, presence: true
  validates :organization_kind_state_name, exclusion: { in: [:closed] }, on: :create
  
  attr_accessible :name, :organization_kind_id, :abbreviation
  attr_accessible :name, :organization_kind_id, :abbreviation, as: :admin
  
  after_create :notify_admins
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q}%") }
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :_close do
      transition active: :closed
    end
  end
  
  define_defaults_events :close
  define_state_machine_scopes
  
  def self.find_similar(name)
    where("name != ?", name).find_all do |org|
      Levenshtein.distance(name, org.name) < [name.size / 3.0, 3].max
    end
  end
  
  def close!
    transaction do
      _close!
      memberships.non_closed.each &:close!
      projects.non_closed.each &:close!
    end
  end
  
  def surety_name
    name
  end
  
  def merge(organization)
    return if self == organization
    transaction do
      organization.memberships.update_all(organization_id: id)
      organization.projects.update_all(organization_id: id)
      organization.coprojects.each do |project|
        coprojects << projects
      end
      organization.destroy
    end
  end
  
  def kind
    organization_kind.name
  end
  
  def as_json(options)
    { id: id, text: name }
  end
  
private
  
  def notify_admins
    Mailer.notify_new_organization(self).deliver if User.admins.exists?
    true
  end
end
