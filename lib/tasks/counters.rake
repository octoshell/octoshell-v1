namespace :counters do
  task active_projects: :environment do
    counts = Project.unscoped.active.group(:organization_id).count
    counts = Hash[counts.group_by { |a| a[1] }.map do |count, ids|
      Organization.unscoped.where(id: ids.map { |i| i[0] }).
        update_all(active_projects_count: count)
    end]
  end
end
