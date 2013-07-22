class UsersFilter
  def initialize(type, id = nil)
    @type = type
    @id = id
  end
  
  def ids
    send @type, @id
  end
  
  private
  def all(*_)
    User.without_state(:closed).map(&:id)
  end
  
  def from_cluster(id)
    User.without_state(:closed).map do |u|
      if u.all_projects.any? { |p| p.requests.where(cluster_id: id).with_state(:active).any? }
        u.id
      end
    end.compact
  end
  
  def from_project(id)
    Project.find(id).accounts.with_access_state(:allowed).map do |account|
      account.user_id
    end.uniq
  end
  
  def from_organization(id)
    Organization.find(id).memberships.with_state(:active).map(&:user_id).uniq
  end
  
  def from_organization_kind(id)
    OrganizationKind.find(id).organizations.with_state(:active).map do |organization|
      organization.memberships.with_state(:active).map(&:user_id)
    end.flatten.uniq
  end
  
  def with_projects(*_)
    User.without_state(:closed).map do |u|
      if u.all_projects.with_state(:active).any?
        u.id
      end
    end.compact
  end
  
  def with_accounts(*_)
    User.without_state(:closed).map do |u|
      if u.accounts.with_access_state(:allowed).any? { |a| a.project.requests.with_state(:active).any? }
        u.id
      end
    end.compact
  end
  
  def with_refused_accounts(*_)
    User.without_state(:closed).each do |u|
      if u.all_projects.with_state(:active).any? { |p| p.requests.with_state(:blocked).any? }
        u.id
      end
    end.compact
  end
  
  def from_session(id)
    session = Session.find(id)
    User.without_state(:closed).map do |u|
      has_fault_with_session = proc do |s|
        u.faults.where(kind: "survey", reference_id: u.user_surveys.where(survey_id: session.survey_ids).pluck(:id)).with_state(:actual).any? || 
          u.faults.with_state(:actual).where(kind: "report", reference_id: u.reports.where(session_id: session.id)).any?
      end
      if u.faults.with_state(:actual).any? && has_fault_with_session.call
        u.id
      end
    end.compact
  end
  
  def unsuccessful_of_current_session(*_)
    if session = Session.current
      User.without_state(:closed).map do |u|
        has_unsubmitted_surveys = proc { u.user_surveys.where(survey_id: session.survey_ids).without_state(:submitted).any? }
        has_unassessed_reports = proc { Report.where(session_id: session.id, project_id: u.owned_project_ids).without_state(:assessed).any? }
        has_failed_reports = proc { Report.where(session_id: session.id, project_id: u.owned_project_ids).with_state(:assessed).where("illustration_points < 3 or summary_points < 3 or statement_points < 3").any? }
        if has_unsubmitted_surveys.call || has_unassessed_reports.call || has_failed_reports.call
          u.id
        end
      end.compact
    end
  end
end
