# coding: utf-8
class Institute < ActiveRecord::Base
  KINDS = %w(ВУС РАН)
  
  has_many :users
  
  validates :name, presence: true, uniqueness: { scope: :kind }
  validates :kind, inclusion: { in: KINDS }
  
  attr_accessible :name, :kind
end
