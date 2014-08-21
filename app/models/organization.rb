# Организация
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

  belongs_to :country
  belongs_to :city

  validates :name, presence: true, uniqueness: { scope: :organization_kind_id }
  validates :organization_kind, :country, :city, :city_title, presence: true
  validates :organization_kind_state_name, exclusion: { in: [:closed] }, on: :create

  attr_accessible :name, :organization_kind_id, :abbreviation, :country_id, :city_title
  attr_accessible :name, :organization_kind_id, :abbreviation, :country_id, :city_title, as: :admin

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
      with_state(:active).where("lower(name) != ?", name.downcase).find_all do |org|
        Levenshtein.distance(name, org.name) < 5
      end
    end

    def find_for_survey(value)
      find_by_name(value)
    end

    def find_for_survey!(value)
      find_by_name!(value)
    end

    def msu
      find(497)
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
      organization.sureties.each do |surety|
        surety.update_attribute(:organization_id, id)
      end
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

  def to_s
    short_name
  end

  def short_name
    abbreviation? ? abbreviation : name
  end

  def city_title
    city.try(:title_ru)
  end

  def city_title=(title)
    self.city = country.cities.find_or_create_by_title_ru(title.mb_chars) if title.present? && country.present?
  end

private

  def notify_admins
    Mailer.delay.notify_new_organization(self, User.superadmins.pluck(:email)) if User.superadmins.exists?
    true
  end
end
