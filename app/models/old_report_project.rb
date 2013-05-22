class OldReportProject < ActiveRecord::Base
  has_attached_file :materials, {
    hash_data: "report_project/:attachment/:id/:style/:updated_at",
    url: "/system/report_project/:attachment/:id_partition/:style/:filename"
  }
  serialize :exclusive_usage
  serialize :strict_schedule
  
  def fill_to(user)
    transaction do
      # report
      rp = Report::Project.find(id)
      report = user.reports.where(project_id: project.id).first
      report.illustration_points = rp.illustrations_points
      report.statement_points = rp.statement_points
      report.summary_points = rp.summary_points
      # report.materials = rp.materials
      report.save!
      
      # personal survey
      ps = old_report.personal_survey
      personal = user.user_surveys.where(survey_id: 1).first
      { software:           3,
        technologies:       6,
        compilators:        1,
        learning:           2,
        computing:          5,
        request_technology: 4 }.each do |m, id|
        
        value = personal.survey_values.find_by_survey_field_id!(id)
        value.value = ps.send(m)
        value.save!
      end
      
      # projects survey
      projects = user.user_surveys.where(survey_id: 2, project_id: project.id).first
      { lomonosov_intel_hours: 12,
        lomonosov_nvidia_hours: 8,
        chebyshev_hours: 11,
        lomonosov_size: 9,
        chebyshev_size: 10,
        exclusive_usage: 14,
        strict_schedule: 15,
        request_comment: 13 }.each do |m, id|
        
        value = projects.survey_values.find_by_survey_field_id!(id)
        value.value = send(m)
        value.save || raise(value.errors.inspect)
      end
      
      # wanna speak
      
      # scientometrics
      sc = user.user_surveys.where(survey_id: 3, project_id: project.id).first
      { books_count: [20, 0],
        vacs_count: [20, 1],
        lectures_count: [20, 2],
        international_conferences_count: [19, 0],
        russian_conferences_count: [19, 2],
        international_conferences_in_russia_count: [19, 1],
        doctors_dissertations_count: [18, 0],
        candidates_dissertations_count: [18, 1],
        students_count: [23, 0],
        graduates_count: [23, 1],
        your_students_count: [22, 0],
        rffi_grants_count: [17, 0],
        ministry_of_education_grants_count: [17, 1],
        rosnano_grants_count: [17, 2],
        ministry_of_communications_grants_count: [17, 3],
        ministry_of_defence_grants_count: [17, 4],
        ran_grants_count: [17, 5],
        other_russian_grants_count: [17, 6],
        other_intenational_grants_count: [17, 7] }.each do |m, arr|
        
        value = sc.survey_values.find_by_survey_field_id!(arr[0])
        value.value ||= []
        v = value.value
        v[arr[1]] = (send(m) || 0)
        value.value = v
        p value.value.inspect
        value.save || raise(value.errors.inspect)
      end
      
      awards = sc.survey_values.find_by_survey_field_id!(24)
      awards.value = award_names
      awards.save!
    end
  end
  
  def old_report
    OldReport.find(report_id)
  end
  
  def logins
    [chebyshev_logins, lomonosov_logins].each do |logins|
      logins.to_s.split(",").map(&:strip)
    end.flatten.uniq
  end
  
  def project
    @project ||= begin
      login =
        logins.find do |login|
          Account.where(username: login).first
        end
      Account.where(username: login).first.project if login
    end
  end
end
