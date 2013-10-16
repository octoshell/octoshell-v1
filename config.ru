# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run MSU::Application

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == 'octoshell' && password == 'a41c6a95'
  end
end
