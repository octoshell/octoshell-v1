class Report::PersonalData < ActiveRecord::Base
  with_options on: :update do |m|
    m.validates :first_name, :last_name, :middle_name, :email, :phone,
      presence: true
  end
  attr_accessible :first_name, :last_name, :middle_name, :email, :phone
end
