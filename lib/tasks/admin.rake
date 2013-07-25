namespace :admin do
  task :make_admin => :environment do
    user = User.find_by_email(ENV["EMAIL"])
    user.groups << Group.superadmins
  end
  
  task :rebuild_abilities => :environment do
    Ability.redefine!
    Group.superadmins.abilities.update_all available: true
  end
end
