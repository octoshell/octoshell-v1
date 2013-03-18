class Survey::Value < ActiveRecord::Base
  belongs_to :field, foreign_key: :survey_field_id
  belongs_to :user
  belongs_to :reference, polymorphic: true
  
  validates :field, presence: true
  
  validate :presence_validator
  
  def value
    reference ? reference.survey_value : self[:value]
  end
  
  def update_value(value)
    if field.kind == 'aselect'
      self.reference = field.entity_class.find_for_survey(value)
    else
      self.value = value
    end
    save
  end
  
private
  
  def presence_validator
    if !value? && field.required?
      errors.add(:value, :blank)
    end
  end
end
