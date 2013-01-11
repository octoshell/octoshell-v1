# coding: utf-8
class PositionName < ActiveRecord::Base
  include Models::Limitable
  
  has_paper_trail
  
  default_scope order("#{table_name}.name asc")
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name, :autocomplete, as: :admin

  def self.rffi
    find_by_name!('Должность по РФФИ')
  end
  
  def values(q)
    q = q.to_s.strip
    available_values.find_all do |e|
      e =~ Regexp.new(q)
    end
  end
  
  def available_values
    return [] if autocomplete.blank?
    autocomplete.each_line.to_a
  end
end
