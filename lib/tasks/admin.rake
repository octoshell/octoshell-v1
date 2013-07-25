namespace :admin do
  task :make_admin => :environment do
    user = User.find_by_email(ENV["EMAIL"])
    user.groups << Group.superadmin
  end
  
  task :rebuild_abilities => :environment do
    Ability.redefine!
  end
end
