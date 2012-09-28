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
    font = RTF::Font.new(RTF::Font::ROMAN, 'Arial')
     	
    styles = {}
     	
    header = RTF::ParagraphStyle.new
    header.justification = :qr
    header.space_before = 1200
    header.space_after = 300
    styles['header'] = header
    
    title = RTF::ParagraphStyle.new
    title.space_before = 1000
    title.space_after = 1000
    title.justification = :qc
    styles['title'] = title
    
    body = RTF::ParagraphStyle.new
    body.space_after = 300
    styles['body'] = body
    
    footer = RTF::ParagraphStyle.new
    footer.space_before = 300
    footer.justification = :qr
    styles['footer'] = footer
    
    document = RTF::Document.new(font)
    
    template = YAML.load_file("#{Rails.root}/config/surety.rtf")
    
    replacer = lambda do |text|
      text.gsub! %r{\{\{ id \}\}}, id.to_s
      text.gsub! %r{\{\{ organization_name \}\}}, organization.name
      text.gsub! %r{\{\{ user_name \}\}}, user.full_name
      text
    end
    
    template.each do |node|
      style, content = node['style'], node['content']
      document.paragraph(styles[style]) do |p|
        if content.is_a?(Array)
          content.each do |n|
            p << replacer.call(n)
            p.line_break
          end
        else
          p << replacer.call(content)
        end
      end
    end
     	
    document.to_rtf
  end
end
