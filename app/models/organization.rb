class Organization < ActiveRecord::Base
  has_paper_trail
  
  delegate :state_name, to: :organization_kind, prefix: true, allow_nil: true
  
  attr_accessor :merge_id
  
  has_many :projects
  has_many :users, through: :sureties
  has_many :memberships
  has_and_belongs_to_many :coprojects, class_name: :Project
  belongs_to :organization_kind
  has_many :subdivisions
  
  validates :name, presence: true, uniqueness: { scope: :organization_kind_id }
  validates :organization_kind, presence: true
  validates :organization_kind_state_name, exclusion: { in: [:closed] }, on: :create
  
  attr_accessible :name, :organization_kind_id, :abbreviation
  attr_accessible :name, :organization_kind_id, :abbreviation, as: :admin
  
  after_create :notify_admins
  
  scope :finder, lambda { |q| where("lower(name) like :q", q: "%#{q.mb_chars.downcase}%").order("name asc") }
  
  state_machine initial: :active do
    state :active
    state :closed
    
    event :close do
      transition :active => :closed
    end
    
    # todo: validate org for absence of projects and members
  end
  
  class << self
    def find_similar(name)
      active.where("lower(name) != ?", name.downcase).find_all do |org|
        Levenshtein.distance(name, org.name) < 5
      end
    end

    def find_for_survey(value)
      find_by_name(value)
    end

    def find_for_survey!(value)
      find_by_name!(value)
    end
  end
  
  def survey_value
    name
  end

  def sureties
    Surety.joins(:project).where(project_id: project_ids)
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
        self.coprojects = (coprojects + projects).uniq
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

  def link_name
    short_name
  end
  
  def short_name
    abbreviation? ? abbreviation : name
  end
  
private
  
  def notify_admins
    Mailer.notify_new_organization(self).deliver if User.admins.exists?
    true
  end
end
