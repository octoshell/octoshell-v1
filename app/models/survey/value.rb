class Survey::Value < ActiveRecord::Base
  belongs_to :field, foreign_key: :survey_field_id
  belongs_to :user
  belongs_to :reference, polymorphic: true
  
  validates :field, presence: true
  
  def update_value(value)
    if field.kind == 'aselect'
      record = survey_field.entity_class.find_by_name(value)
      update_attribute(:reference, record)
    else
      update_attribute(:value, value)
    end
  end
end
