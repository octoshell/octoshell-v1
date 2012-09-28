class Settings
  include ActiveSupport::Configurable
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :surety_ticket_question_id
  
  @@settings = YAML.load_file("#{Rails.root}/config/settings.yml")[:settings]
  @@settings.each do |key, value|
    self.config.send "#{key}=", value
    self.class.delegate key, to: :config
  end
  
  def initialize
    @@settings.each do |key, value|
      self.send "#{key}=", value
    end
  end
  
  def self.reload
    @@settings = nil
  end
  
  def self.update(settings)
    File.open("#{Rails.root}/config/settings.yml", "w+") do |file|
      file.write({ settings: settings.to_hash }.to_yaml)
    end
    @@settings = YAML.load_file("#{Rails.root}/config/settings.yml")[:settings]
  end
  
  def id
    0
  end
  
  def persisted?
    true
  end
end
