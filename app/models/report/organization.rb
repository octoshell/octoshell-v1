# coding: utf-8
class Report::Organization < ActiveRecord::Base
  TYPES = [
    'Российский ВУЗ',
    'Институт РАН',
    'Российсая коммерческая компания',
    'Зарубежная организация',
    'Другое'
  ]
  attr_accessible :name, :subdivision, :position, :organization_type
end
