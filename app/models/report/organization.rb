# coding: utf-8
class Report::Organization < ActiveRecord::Base
  TYPES = [
    'Российский ВУЗ',
    'Институт РАН',
    'Российсая коммерческая компания',
    'Зарубежная организация',
    'Другое'
  ]

  with_options on: :update do
    validates :name, :subdivision, :position, :organization_type, presence: true
    validates :organization_type, inclusion: { in: TYPES }
  end

  attr_accessible :name, :subdivision, :position, :organization_type
end
