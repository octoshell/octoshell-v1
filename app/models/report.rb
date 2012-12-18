class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :project
  belongs_to :user

  class PersonalData < Entity
    ensure_attributes :last_name, :first_name, :middle_name, :email, :phone, :confirm_data
  end
  serialize :personal_data, Report::PersonalData

  #def personal_data
  #self[:personal_data]
  #end

  def personal_data=(personal_data)
    self[:personal_data] = personal_data
  end

  def personal_data_attributes=(attributes)
    self.personal_data = PersonalData.new(attributes)
  end

  class Organization < Entity
    ensure_attributes :name, :subdivision, :position
  end
  
  def organizations
    user.membershiped_organizations.map do |org|
      Organization.new(name: org.name, subdivision: "", position: "")
    end
  end

  def organizations_attributes=(organizations)
    self.organizations = organizations.map do |attributes|
      Organization.new(attributes)
    end
  end

  def organizations=(organizations)
    self[:organizations] = organizations.map(&:attributes)
  end

  class PersonalSurvey < Entity
  end

  class Request < Entity
    ensure_attributes :hours, :size, :full_power, :strict_schedule, :comment    
  end

  def request
    Request.new(self[:request] || {})
  end

  def request=(attributes)
    self[:request] = attributes
  end
end
