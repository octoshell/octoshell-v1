source 'https://rubygems.org'

gem 'rails', '3.2.6'
gem 'sqlite3'
gem 'jquery-rails'
gem 'unicorn'
gem 'capistrano'
gem 'rvm-capistrano'
gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails'
gem 'cancan', github: 'ryanb/cancan', branch: '2.0'
gem 'simple_form'
gem 'paranoia'
gem 'paper_trail'
gem 'resque'
gem 'sorcery'
gem 'slim'
gem 'state_machine'
gem 'mailgun-rails'
gem 'redcarpet'
gem 'fivemat'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'

group :test, :development do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'guard-rspec'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'database_cleaner'
end

group :assets do
  gem 'less-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
