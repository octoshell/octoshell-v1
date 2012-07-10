# coding: utf-8
class Organization < ActiveRecord::Base
  KINDS = %w(ВУС РАН)
  
  has_many :sureties
  has_many :users, through: :sureties
  
  validates :name, presence: true, uniqueness: { scope: :kind }
  validates :kind, presence: true
  validates :kind, inclusion: { in: KINDS }
  
  attr_accessible :name, :kind
end
