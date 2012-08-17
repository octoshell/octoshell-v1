namespace :db do
  task :clear => :environment do
     DatabaseCleaner.strategy = :truncation
     DatabaseCleaner.clean
  end
end
