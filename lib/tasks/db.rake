namespace :db do
  task :clear => :environment do
     DatabaseCleaner.strategy = :truncation
     DatabaseCleaner.clean
  end
  
  task :backup => :environment do
    time = Time.current
    system "pg_dump -f /var/www/msu/shared/backups/#{time.to_i} -F tar octoshell"
  end
  
  task :create_old_history_items => :environment do
    Report.find_each do |report|
      user = report.user
      report.versions.each do |v|
        if v.changeset["state"] == ["editing", "assessing"]
          i = user.track! :report_assessing, report, report.expert
          i.update_column :created_at, v.created_at
        end

        if v.changeset["state"] == ["assessing", "editing"]
          i = user.track! :report_declined, report, report.expert
          i.update_column :created_at, v.created_at
        end

        if v.changeset["state"] == ["editing", "submitted"]
          i = user.track! :report_submitted, report, report.expert
          i.update_column :created_at, v.created_at
        end

        if v.changeset["state"] == ["assessing", "assessed"]
          i = user.track! :report_assessed, report, report.expert
          i.update_column :created_at, v.created_at
        end
      end
    end
  end
end
