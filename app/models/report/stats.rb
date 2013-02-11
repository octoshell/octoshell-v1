class Report::Stats
  def initialize
    @reports = Report.with_state(:assessed).
      includes(:personal_data, :organizations, :projects)
  end
  
  def organizations_count_by_kind
    data = []
    reports_grouped_by_org_kind.each do |kind, reports|
      data << {
        label: kind.gsub(' ', "\n"),
        value: reports.size
      }
    end
    data
  end
  
  def projects_count_by_organization_kind
    data = []
    reports_grouped_by_org_kind.each do |kind, reports|
      data << {
        label: kind.gsub(' ', "\n"),
        value: reports.sum { |r| r.projects.size }
      }
    end
    data
  end
  
private
  
  def reports_grouped_by_org_kind
    @reports_grouped_by_org_kind ||= begin
      @reports.group_by { |r| r.organizations.first.organization_type }
    end
  end
end
