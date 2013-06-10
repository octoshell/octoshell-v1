namespace :cleanup do
  task :session_archives => :environment do
    Dir["#{Rails.root}/public/archive-*"].each do |filename|
      if File.new(filename).ctime < 1.day.ago
        File.unlink filename
      end
    end
  end
end
