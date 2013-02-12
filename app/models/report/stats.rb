class Report::Stats
  def initialize
    @reports = Report.with_state(:assessed).
      includes(:personal_data, :organizations, :projects)
  end
  
  def organizations_count_by_kind
    reports_grouped_by_org_kind.inject([]) do |data, group|
      kind, reports = group
      data << [kind, reports.size]
    end.extend(Chartable)
  end
  
  def projects_count_by_organization_kind
    data = []
    data = reports_grouped_by_org_kind.inject([]) do |data, group|
      kind, reports = group
      data << [kind, reports.sum { |r| r.projects.size }]
    end
    data << [
      msu_organization.abbreviation,
      msu_organization_reports.sum { |r| r.projects.size }
    ]
    msu_subdivisions.each do |subdivision, reports|
      data << [subdivision, reports.sum { |r| r.projects.size } ]
    end
    data.extend(Chartable)
  end
  
private
  
  def reports_grouped_by_org_kind
    @reports_grouped_by_org_kind ||= begin
      @reports.group_by { |r| r.organizations.first.organization_type }
    end
  end
  
  def msu_organization
    ::Organization.find(497)
  end
  
  def msu_organization_reports
    @reports.find_all do |report|
      report.organization == msu_organization
    end
  end
  
  def msu_subdivisions
    msu_organization_reports.group_by do |report|
      report.organizations.first.subdivision
    end
  end
end
