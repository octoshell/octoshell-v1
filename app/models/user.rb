class User < ActiveRecord::Base
  authenticates_with_sorcery!
  
  attr_reader :new_institute
  
  has_many :accounts
  has_many :credentials
  has_many :requests
  has_many :projects
  belongs_to :institute
  
  validates :first_name, :last_name, :email, :institute, presence: true
  validates :password, confirmation: true, length: { minimum: 6 }
  validates :email, uniqueness: true
  
  attr_accessible :first_name, :last_name, :middle_name, :email, :password,
    :password_confirmation, :remember_me, :new_institute, :institute_id
  
  def all_requests
    Request.joins(project: :accounts).where(accounts: { user_id: id })
  end
  
  def new_institute=(attributes)
    if attributes.values.any?(&:present?)
      self.institute = nil
      @new_institute = build_institute do |institute|
        institute.assign_attributes(attributes)
      end
    end
  end
end
