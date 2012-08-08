class AdditionalTicketField < ActiveRecord::Base
  attr_accessible :name, :required, :hint, as: :admin
  
  validates :name, presence: true
end
