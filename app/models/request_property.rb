# Дополнительное поле заявки
class RequestProperty < ActiveRecord::Base
  include Models::Limitable
  
  belongs_to :request
  
  validates :request, presence: true
  
  attr_accessible :value, as: :admin
end
