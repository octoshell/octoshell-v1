namespace :cohortes do
  task :dump => :environment do
    Cohort::KINDS.each { |k| c = Cohort.new; c.kind = k; c.dump }
  end
end
