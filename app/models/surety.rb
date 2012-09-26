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
    state :active
    state :declined
    state :closed
    
    event :_activate do
      transition pending: :active
    end
    
    event :_decline do
      transition pending: :declined
    end
    
    event :_close do
      transition any => :closed
    end
  end
  
  define_defaults_events :activate, :decline, :close
  
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
    
    header = RTF::ParagraphStyle.new
    header.justification = :qr
    header.space_before = 1200
    header.space_after = 300
    
    title = RTF::ParagraphStyle.new
    title.space_before = 1000
    title.space_after = 1000
    title.justification = :qc
    
    body = RTF::ParagraphStyle.new
    body.space_after = 300
    
    document = RTF::Document.new(font)
    
    document.paragraph(header) do |p|
      8.times { p.line_break }
      p << "Ректору"
      p.line_break
      p << "Московского государственного университета"
      p.line_break
      p << "имени М.В. Ломоносова"
      p.line_break
      p << "академику В.А. Садовничему"
    end
    document.paragraph(title) do |p|
      p << "Глубокоуважаемый Виктор Антонович!"
    end
    document.paragraph(body) do |p|
      p << "Просим Вас рассмотреть вопрос о предоставлении доступа на суперкомпьютерный комплекс НИВЦ МГУ номер #{id} на сотрудника #{organization.name} #{user.full_name}"
    end
    document.paragraph(body) do |p|
      p << "Гарантируем использование предоставленных ресурсов только для указанных задач и полное соблюдение правил работы на суперкомпьютерном комплексе НИВЦ МГУ, опубликованных по адресу http://parallel.ru/cluster/rules/."
    end
    document.paragraph(body) do |p|
      p << "Выделенные ресурсы будут использованы исключительно для проведения расчетов в рамках нашей основной деятельности."
    end
    document.to_rtf
  end
end
