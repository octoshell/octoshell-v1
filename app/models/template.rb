class Template < ActiveRecord::Base
  validates :subject, presence: true
  
  attr_accessible :subject, :message, as: :admin
end
