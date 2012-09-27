# coding: utf-8
require 'rtf'

class Surety < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :state_name, to: :organization, prefix: true, allow_nil: true
  
  belongs_to :user
  belongs_to :organization
  
  validates :user, :organization, presence: true
  validates :organization_state_name, exclusion: { in: [:closed] }, on: :create
  
  attr_accessible :organization_id
  attr_accessible :organization_id, :user_id, as: :admin
  
  state_machine initial: :pending do
    state :pending
    state :confirmed
    state :active
    state :declined
    state :closed
    
    event :_confirm do
      transition pending: :confirmed
    end
    
    event :_unconfirm do
      transition confirmed: :pending
    end
    
    event :_activate do
      transition [:confirmed, :pending] => :active
    end
    
    event :_decline do
      transition [:confirmed, :pending] => :declined
    end
    
    event :_close do
      transition [:pending, :confirmed, :active, :declined] => :closed
    end
  end
  
  define_defaults_events :activate, :decline, :close, :confirm, :unconfirm
  
  define_state_machine_scopes
  
  def activate!
    transaction do
      _activate!
      user.revalidate!
    end
  end
  
  def close!(message = nil)
    self.comment = message
    transaction do
      _close!
      user.revalidate!
    end
  end
  
  def to_rtf
    template = File.read("#{Rails.root}/config/surety.rtf")
    template.gsub! /\\\{\\\{ surety.id \\\}\\\}/, id.to_s
    template.gsub! /\\\{\\\{ surety.organization.surety_name \\\}\\\}/, organization.surety_name
    template.gsub! /\\\{\\\{ surety.user.full_name \\\}\\\}/, user.full_name
    template
  end
end
