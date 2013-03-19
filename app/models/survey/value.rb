class Survey::Value < ActiveRecord::Base
  belongs_to :field, foreign_key: :survey_field_id
  belongs_to :user
  belongs_to :reference, polymorphic: true
  
  validates :field, presence: true
  
  validates :value, presence: true, on: :update, if: :has_presence_validator?
  validates :value, inclusion: { in: proc(&:allowed_values) }, if: :has_inclusion_validator?
  
  serialize :value
  
  def value
    reference ? reference.survey_value : self[:value]
  end
  
  def update_value(value)
    self.value = value
    if field.kind == 'aselect'
      method = field.strict_collection? ? :find_for_survey! : :find_for_survey
      if record = field.entity_class.send(method, value)
        self.reference = record
      end
    end
    save
  end
  
  def allowed_values
    field.collection_values
  end
  
private
  
  def has_presence_validator?
    field.required?
  end
  
  def has_inclusion_validator?
    field.strict_collection? && field.kind != 'aselect'
  end
end
