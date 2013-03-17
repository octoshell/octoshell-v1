class UserSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  belongs_to :project
  
  validates :user, :survey, presence: true
  
  state_machine :state, initial: :pending do
    state :pending
    state :filling
    state :submitted
    
    event :accept do
      transition pending: :filling
    end
    
    event :submit do
      transition filling: :submitted
    end
  end
  
  def field_value(id)
    value = find_value(id)
    value.reference || value.value
  end
  
  def fill_values(fields)
    transaction do
      fields.each do |id, value|
        find_value(id).update_value(value)
      end
    end
    true
  end
  
private
  
  def find_value(id)
    condition = { survey_field_id: id, user_id: user.id }
    Survey::Value.where(condition).first_or_create! do |s|
      s.field = Survey::Field.find(id)
      s.user = user
    end
  end
  
end
