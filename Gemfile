source 'https://rubygems.org'

gem 'rails'
gem 'pg'
gem 'jquery-rails'
gem 'simple_form'
gem 'paper_trail'
gem 'sorcery', github: 'releu/sorcery'
gem 'slim'
gem 'state_machine'
gem 'paperclip'
gem 'ransack', github: 'ernie/ransack'
gem 'useragent', '0.5.0'
gem 'kaminari'
gem 'redcarpet', '1.17.2'
gem 'cocaine'
gem 'liquid'
gem 'rtf'
gem 'levenshtein-ffi', require: 'levenshtein'
gem 'validates_email_format_of'
gem 'virtus'
gem 'maymay', github: 'redstonelabs/maymay'
gem 'rubyzip', require: 'zip/zip'
gem 'russian'
gem 'breadcrumbs_on_rails'
gem 'delayed_job_active_record'
gem 'net-ssh'
gem "openssh-key-checker", git: "git://gist.github.com/5865109.git"
gem "delorean"
gem "json", "1.7.7"

group :development do
  gem 'capistrano'
  gem 'quiet_assets'
end

group :development, :production do
  gem 'mailgun-rails'
end

group :test, :development do
  gem 'poltergeist', github: 'brutuscat/poltergeist'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'ci_reporter'
end

group :production do
  gem 'unicorn'
  gem 'airbrake'
  gem 'whenever'
  gem 'therubyracer'
end

group :assets do
  gem 'less-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

