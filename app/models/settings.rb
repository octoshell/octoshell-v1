class Settings
  include ActiveSupport::Configurable
  
  @@settings ||= YAML.load_file("#{Rails.root}/config/settings.yml")['settings']
  @@settings.each do |key, value|
    self.config.send "#{key}=", value
    self.class.delegate key, to: :config
  end
end
