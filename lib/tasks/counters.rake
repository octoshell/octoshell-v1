namespace :counters do
  task active_projects: :environment do
    counts = Project.unscoped.with_state(:active).group(:organization_id).count
    counts = counts.group_by { |a| a[1] }.each do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(active_projects_count: count)
    end
  end

  task active_memberships: :environment do
    counts = Membership.unscoped.joins("inner join users on memberships.user_id = users.id and users.state = 'active'").
      with_state(:active).group(:organization_id).count
    counts.group_by { |a| a[1] }.each do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(active_users_count: count)
    end

    counts = Membership.unscoped.joins("inner join users on memberships.user_id = users.id and users.state = 'sured'").
      with_state(:active).group(:organization_id).count
    counts.group_by { |a| a[1] }.each do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(sured_users_count: count)
    end

    counts = Membership.unscoped.with_state(:active).group(:organization_id).count
    counts.group_by { |a| a[1] }.each do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(active_memberships_count: count)
    end
  end
end
