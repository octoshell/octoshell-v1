class Report::Stats
  def initialize
    @reports = Report.with_state(:assessed).
      includes(:personal_data, :organizations, :projects)
  end
  
  def organizations_count_by_kind
    data = []
    reports_grouped_by_org_kind.each do |kind, reports|
      data << [kind, reports.size]
    end
    data.extend(Chartable)
  end
  
  def projects_count_by_organization_kind
    data = []
    reports_grouped_by_org_kind.each do |kind, reports|
      data << [kind, reports.sum { |r| r.projects.size }]
    end
    data.extend(Chartable)
  end
  
private
  
  def reports_grouped_by_org_kind
    @reports_grouped_by_org_kind ||= begin
      @reports.group_by { |r| r.organizations.first.organization_type }
    end
  end
end
