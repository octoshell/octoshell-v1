class User < ActiveRecord::Base
  has_many :accounts, inverse_of: :user
  has_many :credentials
  has_many :requests
  has_many :owned_projects, class_name: :Project
  has_many :projects, through: :accounts
  has_many :memberships
  has_many :sureties
  has_many :organizations, through: :sureties
  has_many :accesses, through: :credentials
  has_many :tickets
  has_many :user_groups
  
  def admin?
    user_groups.any? do |ug|
      ug.group.name == "superadmins"
    end
  end
end
