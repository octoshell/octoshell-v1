# Страница вики
class Page < ActiveRecord::Base
  has_paper_trail
  
  validates :content, :name, :url, presence: true
  validates :url, uniqueness: true
  
  attr_accessible :name, :content, :url, :locator, :publicized, as: :admin
  
  def to_param
    url
  end
  
  def body
    content
  end
end