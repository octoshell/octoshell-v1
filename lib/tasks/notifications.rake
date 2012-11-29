namespace :notifications do
  task :send_to_admins => :environment do
    notifications = User.admin_notifications_count
    if notifications.any?
      Mailer.admin_notifications(notifications).deliver!
    end
  end
end
