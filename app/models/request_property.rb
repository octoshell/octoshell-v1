class RequestProperty < ActiveRecord::Base
  belongs_to :request
  
  validates :request, presence: true
  
  attr_accessible :value, as: :admin
end
