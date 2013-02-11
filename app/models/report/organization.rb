# coding: utf-8
class Report::Organization < ActiveRecord::Base
  belongs_to :report

  has_paper_trail
  
  TYPES = [
    'Российский ВУЗ',
    'Институт РАН',
    'Российская коммерческая компания',
    'Зарубежная организация',
    'Другое'
  ]

  with_options on: :update do |m|
    m.validates :organization_id, :subdivision, :organization_type, presence: true
    m.validates :position, presence: true, unless: proc { |o| o.other_position? }
    m.validates :organization_type, inclusion: { in: TYPES }
  end

  attr_accessible :organization_id, :subdivision, :position, :organization_type,
    :other_position
end
