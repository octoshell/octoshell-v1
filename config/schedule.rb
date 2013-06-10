set :output, "/var/www/octoshell/shared/log/cron.log"

ruby_path = "/home/evrone/.rbenv/versions/2.0.0-p0/bin/ruby"
job_type :rake, "cd :path && RAILS_ENV=:environment #{ruby_path} bin/rake :task --silent :output"

every 5.minutes do
  rake "counters:active_projects"
end

every 1.hour do
  rake "db:backup"
end

every 1.hour do
  rake "cleanup:session_archives"
end
