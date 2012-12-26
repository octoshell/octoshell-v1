class Report::PersonalData < ActiveRecord::Base
  validates :first_name, :last_name, :middle_name, :email, :phone,
    presence: true
  attr_accessible :first_name, :last_name, :middle_name, :email, :phone
end
