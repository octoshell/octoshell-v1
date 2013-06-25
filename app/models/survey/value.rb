class Survey::Value < ActiveRecord::Base
  has_paper_trail
  
  delegate :user, to: :user_survey
  
  belongs_to :field, foreign_key: :survey_field_id
  belongs_to :user_survey
  belongs_to :reference, polymorphic: true
  
  validates :field, presence: true
  
  with_options on: :update do |opt|
    opt.validates :value, presence: true, if: :has_presence_validator?
    opt.validates :value, inclusion: { in: proc(&:allowed_values) },
      if: :has_inclusion_validator?
    opt.validate :values_matcher, if: proc { |v| v.multiple_values? && v.field.strict_collection?  }
    opt.validates :value, numericality: { greater_than_or_equal_to: 0 },
      if: :number_field?
    opt.validate :scientometric_validator, if: :scientometric_field?
  end
  
  serialize :value
  
  def value
    multiple_values? ? Array(self[:value]) : self[:value]
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
  
  def has_presence_validator?
    field.required?
  end
  
  def has_inclusion_validator?
    field.strict_collection? && field.kind.in?(%w(radio select))
  end
  
  def multiple_values?
    field.kind.in? %w(mselect)
  end
  
  def values_matcher
    value.find_all(&:present?).all? do |v|
      v.in? allowed_values
    end || errors.add(:value, "Не предусмотренное значение")
  end
  
  def number_field?
    field.kind == 'number'
  end
  
  def scientometric_field?
    field.kind == "scientometrics"
  end
  
  def scientometric_validator
    Array(value).all? do |v|
      v.to_i >= 0
    end || errors.add(:value, "Должено быть больше или равное нулю")
  end
end
