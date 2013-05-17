class Survey::Value < ActiveRecord::Base
  belongs_to :field, foreign_key: :survey_field_id
  belongs_to :user_survey
  belongs_to :reference, polymorphic: true
  
  validates :field, presence: true
  
  with_options on: :update do |opt|
    opt.validates :value, presence: true, if: :has_presence_validator?
    opt.validates :value, inclusion: { in: proc(&:allowed_values) },
      if: :has_inclusion_validator?
    opt.validate :values_matcher, if: :multiple_values?
    opt.validates :value, numericality: { greater_than_or_equal_to: 0 },
      if: :number_field?
  end
  
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
    field.strict_collection? && !field.kind.in?(%w(aselect mselect))
  end
  
  def multiple_values?
    field.kind == 'mselect'
  end
  
  def values_matcher
    value.all? do |v|
      v.in? allowed_values
    end
  end
  
  def number_field?
    field.kind == 'number'
  end
end
