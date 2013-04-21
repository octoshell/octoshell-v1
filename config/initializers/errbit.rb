if defined?(Airbrake)
  Airbrake.configure do |config|
    config.api_key = '478461bbf74895e8e9059b0c65ee73a2'
    config.host    = 'errbit.evrone.ru'
    config.port    = 80
    config.secure  = config.port == 443
  end
end
