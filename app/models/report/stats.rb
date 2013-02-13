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
  
  def books_count
    projects.sum &:books_count
  end
  
  def vacs_count
    projects.sum &:vacs_count
  end
  
  def lectures_count
    projects.sum &:lectures_count
  end
  
  def publications_count
    books_count + vacs_count + lectures_count
  end
  
  def international_conferences_count
    projects.sum &:international_conferences_count
  end
  
  def international_conferences_in_russia_count
    projects.sum &:international_conferences_in_russia_count
  end
  
  def russian_conferences_count
    projects.sum &:russian_conferences_count
  end
  
  def conferences_count
    [ international_conferences_count,
      international_conferences_in_russia_count,
      russian_conferences_count ].sum
  end
  
  def doctors_dissertations_count
    projects.sum &:doctors_dissertations_count
  end
  
  def candidates_dissertations_count
    projects.sum &:candidates_dissertations_count
  end
  
  def dissertations_count
    [ doctors_dissertations_count,
      candidates_dissertations_count ].sum
  end
  
  def students_count
    projects.sum &:students_count
  end
  
  def graduates_count
    projects.sum &:graduates_count
  end
  
  def studies_count
    [students_count, graduates_count].sum
  end
  
private

  def projects
    @projects ||= @reports.map(&:projects).flatten
  end
  
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
