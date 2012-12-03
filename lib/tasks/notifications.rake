namespace :notifications do
  task :send_to_admins => :environment do
    notifications = User.admin_notifications_count
    if notifications > 0
      Mailer.admin_notifications.deliver!
    end
  end
end
