# coding: utf-8
class Survey::Field < ActiveRecord::Base
  KINDS = [:radio, :select, :mselect, :string, :text, :aselect]
  ENTITIES = [:organization, :positions]
  
  scope :sorted, order("#{table_name}.weight asc, #{table_name}.name asc")
  
  validates :name, :kind, presence: true
  
  attr_accessible :name, :kind, :collection, :max_values, :weight,
    :required, :entity, :strict_collection, as: :admin
  
  def collection_values
    collection.each_line.find_all &:present?
  end
  
  def entity_source
    case entity.to_sym
    when :organization then
      '/organizations.json'
    when :positions then
      '/positions.json'
    end
  end
end
