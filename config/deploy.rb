require 'bundler/capistrano'
require "rvm/capistrano"
set :rvm_type, :user
set :rvm_ruby_string, '1.9.3@msu'

set :application, "msu"
set :rails_env, "production"
set :domain, "evrone@v1.parallel.ru"
set :repository,  "git@github.com:evrone/msu.git"
set :branch, "master"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :keep_releases, 3
set :normalize_asset_timestamps, false
set :scm, :git

role :app, domain
role :web, domain
role :db,  domain, :primary => true

# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

namespace :deploy do
  desc "Restart Unicorn"
  task :restart do
    run "sv restart ~/services/#{application}_unicorn"
    # run "sv restart ~/services/#{application}_resque"
  end
  
  desc "Make symlinks"
  task :make_symlinks, :roles => :app, :except => { :no_release => true } do
    # Ставим симлинк на конфиги и загрузки
    run "rm -f #{latest_release}/config/database.yml"
    run "ln -s #{deploy_to}/shared/configs/database.yml #{latest_release}/config/database.yml"

    run "rm -rf #{latest_release}/public/uploads"
    run "ln -s #{deploy_to}/shared/uploads #{latest_release}/public/uploads"
  end
end

after 'deploy:finalize_update', 'deploy:make_symlinks'
