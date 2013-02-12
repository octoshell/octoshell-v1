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
  
  def directions_of_science_by_count
    ::Report::Project::DIRECTIONS_OF_SCIENCE.map do |direction|
      [direction, @reports.map(&:projects).flatten.find_all do |p|
        p.directions_of_science.include?(direction)
      end.size]
    end.extend(Chartable)
  end
  
  def directions_of_science_count_by_msu_subdivistions
    msu_subdivisions.map do |subdivision, reports|
      seria = Hash[::Report::Project::DIRECTIONS_OF_SCIENCE.map do |direction|
        [direction, reports.map(&:projects).flatten.find_all do |p|
          p.directions_of_science.include?(direction)
        end.size]
      end]
      [subdivision, seria]
    end
  end
  
  def directions_of_science_count_by_msu_subdivistions_bar
    msu_subdivisions.map do |subdivision, reports|
      seria = ::Report::Project::DIRECTIONS_OF_SCIENCE.map do |direction|
        [direction, reports.map(&:projects).flatten.find_all do |p|
          p.directions_of_science.include?(direction)
        end.size]
      end
      { name: subdivision, data: seria, type: 'column' }
    end
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
