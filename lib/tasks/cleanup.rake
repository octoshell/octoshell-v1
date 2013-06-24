namespace :cleanup do
  task :fix_faults => :environment do
    Fault.where(kind: "report").each do |f|
      f.description = "Не сдан отчет по проекту #{Report.find(f.reference_id).project.title}"
      f.save!
    end
  end
  
  task :session_archives => :environment do
    Dir["#{Rails.root}/public/archive-*"].each do |filename|
      if File.new(filename).ctime < 1.day.ago
        File.unlink filename
      end
    end
  end
end
