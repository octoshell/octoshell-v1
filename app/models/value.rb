class Value < ActiveRecord::Base
  include Models::Paranoid
  
  has_paper_trail
  
  belongs_to :model, polymorphic: true
  belongs_to :field
  
  validates :model, :field, presence: true
  validates :model_id, :uniqueness => { scope: [:model_type, :field_id] }
end
