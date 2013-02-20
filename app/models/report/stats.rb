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
  
  def organizations_count_by_kind_sum
    organizations_count_by_kind.sum(&:last)
  end
  
  def projects_count_by_organization_kind_sum
    projects_count_by_organization_kind.sum(&:last)
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
    data.extend(Chartable)
  end
  
  def projects_count_by_msu_subdivisions
    msu_subdivisions.map do |subdivision, reports|
      [subdivision, reports.sum { |r| r.projects.size } ]
    end.extend(Chartable)
  end
  
  def projects_count_by_msu_subdivisions_sum
    projects_count_by_msu_subdivisions.sum(&:last)
  end
  
  def users_count_by_organization_kind
    data = []
    data = reports_grouped_by_org_kind.inject([]) do |data, group|
      kind, reports = group
      data << [kind, reports.size]
    end
    data << [
      msu_organization.abbreviation,
      msu_organization_reports.size
    ]
    data.extend(Chartable)
  end
  
  def users_count_by_msu_subdivisions
    msu_subdivisions.map do |subdivision, reports|
      [subdivision, reports.size]
    end.extend(Chartable)
  end
  
  def users_count_by_msu_subdivisions_sum
    users_count_by_msu_subdivisions.sum(&:last)
  end
  
  def directions_of_science_by_count
    ::Report::Project::DIRECTIONS_OF_SCIENCE.map do |direction|
      [direction, @reports.map(&:projects).flatten.find_all do |p|
        p.directions_of_science.include?(direction)
      end.size]
    end.extend(Chartable)
  end
  
  def directions_of_science_count_by_msu_subdivisions(direction)
    msu_subdivisions.map do |subdivision, reports|
      sum = reports.sum do |report|
        report.projects.find_all do |p|
          p.directions_of_science.include?(direction)
        end.size
      end
      [subdivision, sum]
    end.extend(Chartable)
  end
  
  def areas_by_count
    ::Report::Project::AREAS.values.flatten.map do |area|
      [area, @reports.map(&:projects).flatten.find_all do |p|
        p.areas.include?(area)
      end.size]
    end.extend(Chartable)
  end
  
  def areas_count_by_msu_subdivisions(area)
    msu_subdivisions.map do |subdivision, reports|
      sum = reports.sum do |report|
        report.projects.find_all do |p|
          p.areas.include?(area)
        end.size
      end
      [subdivision, sum]
    end.extend(Chartable)
  end
  
  def critical_technologies_by_count
    ::Report::Project::CRITICAL_TECHNOLOGIES.map do |tech|
      [tech, @reports.map(&:projects).flatten.find_all do |p|
        p.critical_technologies.include?(tech)
      end.size]
    end.extend(Chartable)
  end
  
  def tech_count_by_msu_subdivisions(tech)
    msu_subdivisions.map do |subdivision, reports|
      sum = reports.sum do |report|
        report.projects.find_all do |p|
          p.critical_technologies.include?(tech)
        end.size
      end
      [subdivision, sum]
    end.extend(Chartable)
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
    :awards_count,
    :lomonosov_intel_hours,
    :lomonosov_nvidia_hours,
    :chebyshev_hours,
    :lomonosov_size,
    :chebyshev_size ].each do |attribute|
    
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
      :ministry_of_education_grants_count,
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
  
  def award_count_by_subdivision
    counts_by_subdivision(:awards_count)
  end
  
  def award_names_by_subdivision
    Hash[msu_subdivisions.map do |subdivision, reports|
      names = reports.map(&:projects).flatten.map do |project|
        project.award_names
      end.find_all(&:present?)
      [subdivision, names]
    end]
  end
  
  def hours_sum
    lomonosov_intel_hours + lomonosov_nvidia_hours + chebyshev_hours
  end
  
  def size_sum
    lomonosov_size + chebyshev_size
  end
  
  def strict_schedule_count
    projects.map(&:strict_schedule).sum &:size
  end
  
  def software_top
    personal_survey_top(:software)
  end
  
  def request_technologies_top
    Hash[personal_surveys.map do |ps|
      ps.request_technology.split(',').map &:strip
    end.flatten.find_all(&:present?).group_by { |t| t }.
    sort_by { |t, tts| tts.size }.first(20).map do |arr|
      key, values = arr
      [key, values.size]
    end]
  end
  
  def technologies_top
    personal_survey_top(:technologies)
  end
  
  def technology_percent(name)
    personal_survey_percent(:technologies, name)
  end
  
  def compilators_top
    personal_survey_top(:compilators)
  end
  
  def compilator_percent(name)
    personal_survey_percent(:compilators, name)
  end
  
  def learning_top
    personal_survey_top(:learning)
  end
  
  def other_learning
    personal_surveys.keep_if do |personal_survey|
      personal_survey.other_learning?
    end
  end
  
  def learning_percent(name)
    personal_survey_percent(:learning, name)
  end
  
  def precision
    personal_survey_top(:precision).to_a.extend(Chartable)
  end
  
  def computing
    personal_survey_top(:computing).to_a.extend(Chartable)
  end
  
  def projects_top(attribute)
    projects.sort_by(&attribute).reverse.find_all do |project|
      project.send(attribute) > 0
    end
  end
  
  def organizations_top(attribute)
    organizations.sort_by do |org, reports|
      reports.sum { |report| report.projects.sum(&attribute) }
    end.reverse.map do |arr|
      org, reports = arr
      val = reports.sum { |report| report.projects.sum(&attribute) }
      org.define_singleton_method(attribute) { val }
      org
    end.find_all { |org| org.send(attribute) > 0 }
  end
  
  def project_requests_top_for_lomonosov_intel_hours
    projects.sort_by(&:lomonosov_intel_hours).reverse
  end
  
  def project_requests_top_for_lomonosov_nvidia_hours
    projects.sort_by(&:lomonosov_nvidia_hours).reverse
  end
  
  def project_requests_top_for_chebyshev_hours
    projects.sort_by(&:chebyshev_hours).reverse
  end
  
  def project_requests_top_for_chebyshev_size
    projects.sort_by(&:chebyshev_size).reverse
  end
  
  def project_requests_top_for_lomonosov_size
    projects.sort_by(&:lomonosov_size).reverse
  end
  
  def organization_requests_top_for_lomonosov_intel_hours
    organizations.map do |org, reports|
      val = reports.sum { |r| r.projects.sum { |p| p.lomonosov_intel_hours } }
      org.define_singleton_method(:lomonosov_intel_hours) { val }
      org
    end.sort_by(&:lomonosov_intel_hours).reverse
  end
  
  def organization_requests_top_for_lomonosov_nvidia_hours
    organizations.map do |org, reports|
      val = reports.sum { |r| r.projects.sum { |p| p.lomonosov_nvidia_hours } }
      org.define_singleton_method(:lomonosov_nvidia_hours) { val }
      org
    end.sort_by(&:lomonosov_nvidia_hours).reverse
  end
  
  def organization_requests_top_for_chebyshev_hours
    organizations.map do |org, reports|
      val = reports.sum { |r| r.projects.sum { |p| p.chebyshev_hours } }
      org.define_singleton_method(:chebyshev_hours) { val }
      org
    end.sort_by(&:chebyshev_hours).reverse
  end
  
  def organization_requests_top_for_chebyshev_size
    organizations.map do |org, reports|
      val = reports.sum { |r| r.projects.sum { |p| p.chebyshev_size } }
      org.define_singleton_method(:chebyshev_size) { val }
      org
    end.sort_by(&:chebyshev_size).reverse
  end
  
  def organization_requests_top_for_lomonosov_size
    organizations.map do |org, reports|
      val = reports.sum { |r| r.projects.sum { |p| p.lomonosov_size } }
      org.define_singleton_method(:lomonosov_size) { val }
      org
    end.sort_by(&:lomonosov_size).reverse
  end
  
  def exclusive_usage
    projects.find_all { |p| p.exclusive_usage.any?(&:present?) }
  end
  
  def wanners_speak
    projects.find_all(&:wanna_speak?)
  end
  
private

  def organizations
    @organizations ||= @reports.group_by(&:organization)
  end

  def personal_survey_percent(attribute, value)
    top = send("#{attribute}_top")
    all = top.sum { |k, v| v }
    current = top[value]
    "#{((current / all.to_f) * 100).round(2)} %"
  end

  def personal_survey_top(attribute)
    Hash[personal_surveys.map(&attribute).flatten.find_all(&:present?).
      group_by { |i| i }.sort_by { |i, iis| - iis.size }.map do |arr|
        key, values = arr
        [key, values.size]
      end]
  end

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
  
  def personal_surveys
    @personal_survey ||= @reports.map &:personal_survey
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
    @msu_organization_reports ||= begin
      
      @reports.find_all do |report|
        report.organization == msu_organization
      end
    end
  end
  
  def msu_subdivisions
    @msu_subdivisions ||= msu_organization_reports.group_by do |report|
      report.organizations.first.subdivision.
        to_s.mb_chars.strip.normalize.to_s
    end
  end
end
