namespace :counters do
  task active_projects: :environment do
    counts = Project.unscoped.with_state(:active).group(:organization_id).count
    counts = counts.group_by { |a| a[1] }.each do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(active_projects_count: count)
    end
  end

  task active_memberships: :environment do
    counts = Membership.unscoped.with_state(:active).group(:organization_id).count
    counts = counts.group_by { |a| a[1] }.each do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(active_memberships_count: count.to_i)
    end
  end
end
