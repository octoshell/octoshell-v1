namespace :clusters do
  task :update_statistics => :environment do
    Cluster.active.each do |cluster|
      cluster.tasks.setup(:get_statistic)
    end
  end
end
