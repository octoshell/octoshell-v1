class WikiUrl < ActiveRecord::Base
  belongs_to :page
  
  validates :page, :url, presence: true
  
  attr_accessible :url, :page_id, as: :admin
end
