# coding: utf-8
require 'rtf'
class Surety < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :user, :organization, to: :project, allow_nil: true
  
  belongs_to :project, inverse_of: :sureties
  has_many :tickets
  has_many :surety_members, inverse_of: :surety
  belongs_to :direction_of_science
  has_and_belongs_to_many :critical_technologies
  
  validates :direction_of_science, :boss_full_name, :boss_position,
    :project, presence: true
  validates :critical_technology_ids, length: { minimum: 1, message: 'выберите не менее %{count}' }
  validates :cpu_hours, :gpu_hours, :size, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :boss_full_name, :boss_position, :direction_of_science_id,
    :critical_technology_ids, :surety_members_attributes, :cpu_hours, :gpu_hours,
    :size
  
  accepts_nested_attributes_for :surety_members
  
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
    true
  end
  
  def html_template
    t = Liquid::Template.parse(File.read("#{Rails.root}/config/surety.liquid"))
    t.render({
      'id'                    => id,
      'organization_name'     => organization.surety_name,
      'user_name'             => user.full_name,
      'boss_full_name'        => boss_full_name,
      'boss_position'         => boss_position,
      'members'               => surety_members.map(&:full_name),
      'project_name'          => project.name,
      'direction_of_science'  => direction_of_science.name,
      'critical_technologies' => critical_technologies.map(&:name),
      'project_description'   => project.description,
      'cpu_hours'             => cpu_hours,
      'gpu_hours'             => gpu_hours,
      'size'                  => size,
      'date'                  => Date.today.to_s,
      'other_organizations'   => project.organizations.map(&:name)
    })
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
  
  def load_scan(file)
    if file.blank?
      errors.add(:base, "Не приложен файл")
      return false
    end
    
    self.tickets.create! do |ticket|
      ticket.user = user
      ticket.subject = "Скан к поручительству ##{id}"
      ticket.url = "/sureties/#{id}"
      ticket.ticket_question_id = Settings.surety_ticket_question_id
      ticket.message = "Скан в приложении"
      ticket.attachment = file
    end
  end
end
