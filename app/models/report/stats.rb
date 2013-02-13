# coding: utf-8
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
  
  [ :books_count,
    :vacs_count,
    :lectures_count,
    :international_conferences_count,
    :international_conferences_in_russia_count,
    :russian_conferences_count,
    :doctors_dissertations_count,
    :candidates_dissertations_count,
    :students_count,
    :graduates_count,
    :your_students_count,
    :rffi_grants_count,
    :ministry_of_education_grants_count,
    :rosnano_grants_count,
    :ministry_of_communications_grants_count,
    :ministry_of_defence_grants_count,
    :ran_grants_count,
    :other_russian_grants_count,
    :other_intenational_grants_count,
    :awards_count ].each do |attribute|
    
    define_method attribute do
      projects.sum &attribute
    end
  end
  
  def publications_count
    books_count + vacs_count + lectures_count
  end
  
  def publications_count_by_subdivision
    counts_by_subdivision(:books_count, :vacs_count, :lectures_count)
  end
  
  def conferences_count
    [ international_conferences_count,
      international_conferences_in_russia_count,
      russian_conferences_count ].sum
  end
  
  def conferences_count_by_subdivision
    counts_by_subdivision(
      :international_conferences_count,
      :international_conferences_in_russia_count,
      :russian_conferences_count
    )
  end
  
  def dissertations_count
    [ doctors_dissertations_count,
      candidates_dissertations_count ].sum
  end
  
  def dissertations_count_by_subdivision
    counts_by_subdivision(
      :doctors_dissertations_count,
      :candidates_dissertations_count
    )
  end
  
  def studies_count
    [students_count, graduates_count].sum
  end
  
  def studies_count_by_subdivision
    counts_by_subdivision(:students_count, :graduates_count)
  end
  
  def your_students_count_by_subdivision
    counts_by_subdivision(:your_students_count)
  end
  
  def grants_count
    [ rffi_grants_count,
      ministry_of_education_grants_count,
      rosnano_grants_count,
      ministry_of_communications_grants_count,
      ministry_of_defence_grants_count,
      ran_grants_count,
      other_russian_grants_count,
      other_intenational_grants_count ].sum
  end
  
  def grants_count_by_subdivision
    counts_by_subdivision(
      :rffi_grants_count,
      :ministry_of_defence_grants_count,
      :rosnano_grants_count,
      :ministry_of_communications_grants_count,
      :ministry_of_defence_grants_count,
      :ran_grants_count,
      :other_russian_grants_count,
      :other_intenational_grants_count
    )
  end
  
  def award_names
    group = projects.map(&:award_names).flatten.
      find_all(&:present?).group_by { |award| award }
    Hash[group.map do |award, awards|
      [award, awards.size]
    end]
  end
  
  def award_names_by_subdivision
    counts_by_subdivision(:awards_count)
  end
  
private

  def counts_by_subdivision(*attributes)
    Hash[msu_subdivisions.map do |subdivision, reports|
      projects = reports.map(&:projects).flatten
      counts = attributes.map do |attr|
        projects.sum(&attr)
      end
      counts << counts.sum
      [subdivision, counts]
    end]
  end

  def projects
    @projects ||= @reports.map(&:projects).flatten
  end
  
  def reports_grouped_by_org_kind
    @reports_grouped_by_org_kind ||= begin
      @reports.group_by { |r| r.organizations.first.organization_type }
    end
  end
  
  def msu_organization
    @msu_organization ||= ::Organization.find(497)
  end
  
  def msu_organization_reports
    @reports.find_all do |report|
      report.organization == msu_organization
    end
  end
  
  def msu_subdivisions
    @msu_subdivisions ||= msu_organization_reports.group_by do |report|
      report.organizations.first.subdivision
    end
  end
end