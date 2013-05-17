set :rbenv_ruby_version, "2.0.0-p0"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
  'RBENV_VERSION' => rbenv_ruby_version
}
set :bundle_flags, "--deployment --quiet --binstubs --shebang ruby-local-exec"
set :rake, "bin/rake"

require 'bundler/capistrano'
require "cocaine"

set :application, "octoshell"
set :rails_env, "production"
set :domain, "evrone@v2.parallel.ru"
set :repository,  "git@github.com:evrone/octoshell.git"
set :branch, "reports"
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

namespace :app do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    exec %{ssh #{domain} -t -c 'cd #{current_path} && bin/rails c #{rails_env}'"}
  end
end

namespace :deploy do
  desc "Restart Unicorn and Resque"
  task :restart do
    run "sv restart ~/services/octoshell_unicorn"
  end
  
  desc "Make symlinks"
  task :make_symlinks, :roles => :app, :except => { :no_release => true } do
    # Ставим симлинк на конфиги и загрузки
    run "rm -f #{latest_release}/config/database.yml"
    run "ln -s #{deploy_to}/shared/configs/database.yml #{latest_release}/config/database.yml"
    
    run "rm -f #{latest_release}/config/surety.liquid"
    run "ln -s #{deploy_to}/shared/configs/surety.liquid #{latest_release}/config/surety.liquid"
    
    run "rm -f #{latest_release}/config/surety.rtf"
    run "ln -s #{deploy_to}/shared/configs/surety.rtf #{latest_release}/config/surety.rtf"
    
    run "rm -f #{latest_release}/config/settings.yml"
    run "ln -s #{deploy_to}/shared/configs/settings.yml #{latest_release}/config/settings.yml"
    
    run "rm -rf #{latest_release}/public/uploads"
    run "ln -s #{deploy_to}/shared/uploads #{latest_release}/public/uploads"
    
    run "rm -rf #{latest_release}/public/images"
    run "ln -s #{deploy_to}/shared/images #{latest_release}/public/images"
    
    run "ln -s #{deploy_to}/shared/wiki.git #{latest_release}/db"
  end
end

after 'deploy:finalize_update', 'deploy:make_symlinks'
