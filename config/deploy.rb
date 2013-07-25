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
if ENV["STAGE"]
  set :domain, "evrone@v2.parallel.ru"
else
  set :domain, "evrone@users.parallel.ru"
end
# set :port, 22199
set :repository,  "git@github.com:evrone/octoshell.git"
set :branch, "master"
set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :keep_releases, 3
set :normalize_asset_timestamps, false
set :scm, :git
set :ssh_options, { forward_agent: true }

role :app, domain
role :web, domain
role :db,  domain, :primary => true

unless ENV["STAGE"]
  set :whenever_command, "bundle exec whenever"
  require "whenever/capistrano"
end

namespace :app do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    exec %{ssh #{domain} -t -c 'cd #{current_path} && bin/rails c #{rails_env}'"}
  end
end

namespace :deploy do
  task :restart do
    run "sv restart ~/services/octoshell_unicorn"
    run "sv restart ~/services/octoshell_delayed_job"
  end
  
  task :load_default_db do
    run "psql -d octoshell -a -f #{deploy_to}/current/db/structure.sql"
  end
  
  task :make_defaults do
    run "mkdir -p #{deploy_to}/shared/configs"
    top.upload "config/database.yml.default",  "#{deploy_to}/shared/configs/database.yml"
    top.upload "config/surety.liquid.default", "#{deploy_to}/shared/configs/surety.liquid"
    top.upload "config/surety.rtf.default",    "#{deploy_to}/shared/configs/surety.rtf"
    top.upload "config/settings.yml.default",  "#{deploy_to}/shared/configs/settings.yml"
  end
  
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
after 'deploy:setup', 'deploy:make_defaults'
