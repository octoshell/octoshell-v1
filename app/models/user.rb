class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  attr_reader :new_institute
  attr_reader :institute_id
  
  has_many :accounts, inverse_of: :user
  has_many :credentials
  has_many :requests
  has_many :owned_projects, class_name: :Project
  has_many :projects, through: :accounts
  has_many :confirmations
  has_many :institutes, through: :confirmations
  
  validates :first_name, :last_name, :email, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, on: :update, if: :password?
  validates :email, uniqueness: true
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_institute, :institute_id
  
  def all_requests
    Request.joins(project: :accounts).where(accounts: { user_id: id })
  end
  
  def new_institute=(attributes)
    if attributes.values.any?(&:present?)
      @new_institute = institutes.build(attributes)
    end
  end
  
  def institute_id=(id)
    return if id.blank?
    raise 'Only for new records' if persisted?
    self.institutes = [Institute.find(id)]
  end
  
  def password?
    password.present?
  end
  
  def full_name
    [first_name, middle_name, last_name].find_all(&:present?).join(' ')
  end
end
