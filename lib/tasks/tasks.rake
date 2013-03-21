namespace :tasks do
  task :create => :environment do
    Task.reorder('id asc').with_state(:pending).each &:run
  end
end
