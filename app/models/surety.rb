# coding: utf-8
require 'rtf'
class Surety < ActiveRecord::Base
  has_paper_trail
  
  default_scope order("#{table_name}.id desc")
  
  delegate :user, :organization, :direction_of_sciences, :critical_technologies,
    to: :project, allow_nil: true
  
  belongs_to :project, inverse_of: :sureties
  has_many :tickets
  has_many :surety_members, inverse_of: :surety
  
  validates :boss_full_name, :boss_position, :project, presence: true
  validates :cpu_hours, :gpu_hours, :size, numericality: { greater_than_or_equal_to: 0 }
  
  attr_accessible :boss_full_name, :boss_position, :surety_members_attributes,
    :cpu_hours, :gpu_hours, :size, :project_id
  
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
      'id'                     => id,
      'organization_name'      => organization.surety_name,
      'boss_full_name'         => boss_full_name,
      'boss_position'          => boss_position,
      'members'                => surety_members.map(&:full_name),
      'project_name'           => project.name,
      'direction_of_sciences'  => direction_of_sciences.map(&:name),
      'critical_technologies'  => critical_technologies.map(&:name),
      'project_description'    => project.description,
      'cpu_hours'              => cpu_hours,
      'gpu_hours'              => gpu_hours,
      'size'                   => size,
      'date'                   => Date.today.to_s,
      'other_organizations'    => project.organizations.map(&:name)
    })
  end
  
  def to_rtf
    font = RTF::Font.new(RTF::Font::ROMAN, 'Arial')
    
    styles = {}
    
    header = RTF::ParagraphStyle.new
    header.justification = :qr
    header.space_before = 300
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
    
    dl = RTF::ParagraphStyle.new
    dl.space_after = 300
    dl.left_indent = 100
    styles['dl'] = dl
    
    footer = RTF::ParagraphStyle.new
    footer.space_before = 300
    styles['footer'] = footer
    
    document = RTF::Document.new(font)
    
    template = YAML.load_file("#{Rails.root}/config/surety.rtf")
    unless project.organizations.any?
      template.delete_if do |row|
        content = row['content']
        if content.is_a?(Array)
          content.delete_if do |content|
            content.include?("{{ other_organizations }}")
          end
          false
        else
          content.include?("{{ other_organizations }}")
        end
      end
    end
    
    replacer = lambda do |text|
      text.gsub! %r{\{\{ id \}\}}, id.to_s
      text.gsub! %r{\{\{ organization_name \}\}}, organization.name
      text.gsub! %r{\{\{ boss_full_name \}\}},    boss_full_name
      text.gsub! %r{\{\{ boss_position \}\}},     boss_position
      text.gsub! %r{\{\{ members \}\}}, begin
        surety_members.map(&:full_name).join(', ')
      end
      text.gsub! %r{\{\{ project_name \}\}},      project.name
      text.gsub! %r{\{\{ direction_of_sciences \}\}}, begin
        direction_of_sciences.map(&:name).join(', ')
      end
      text.gsub! %r{\{\{ critical_technologies \}\}}, begin
        critical_technologies.map(&:name).join(', ')
      end
      text.gsub! %r{\{\{ project_description \}\}}, project.description
      text.gsub! %r{\{\{ cpu_hours \}\}}, cpu_hours.to_s
      text.gsub! %r{\{\{ gpu_hours \}\}}, gpu_hours.to_s
      text.gsub! %r{\{\{ size \}\}}, size.to_s
      text.gsub! %r{\{\{ date \}\}}, Date.today.to_s
      text.gsub! %r{\{\{ other_organizations \}\}}, begin
        project.organizations.map(&:name).join(', ')
      end
      text
    end
    
    document.paragraph(styles['body']) do |p|
      5.times { p.line_break }
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

  def link_name
    I18n.t('.open', default: 'Open')
  end
end
