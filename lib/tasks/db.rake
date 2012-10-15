namespace :db do
  task :clear => :environment do
     DatabaseCleaner.strategy = :truncation
     DatabaseCleaner.clean
  end
  
  task :backup => :environment do
    time = Time.current
    system "pg_dump -f /var/www/msu/shared/backups/#{time.to_i} -F tar msu"
  end
end
