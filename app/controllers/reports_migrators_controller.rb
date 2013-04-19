class ReportsMigratorsController < Admin::ApplicationController
  def show
    @report = OldReport.where(state: 'assessed').first
    @user = @report.user
  end
  
  def create
    params[:rp].each do |rp_id, p_id|
      OldReportProject.where(id: rp_id).update_all project_id: p_id
    end if params[:rp]
    (OldReportProject.find(params[:rp].first.first).report rescue OldReport.where(state: 'assessed').first).destroy
    redirect_to reports_migrator_path
  end
  
  def create_project
    rp = OldReportProject.find(params[:rp_id])
    project = Project.new do |p|
      p.title = rp.ru_title
      p.user = rp.report.user
      p.organization = rp.report.user.organizations.first || Organization.first
    end
    card = project.build_card do |card|
      card.name         = rp.ru_title
      card.en_name      = rp.en_title
      card.driver       = rp.ru_driver
      card.en_driver    = rp.en_driver
      card.strategy     = rp.ru_strategy
      card.en_strategy  = rp.en_strategy
      card.objective    = rp.ru_objective
      card.en_objective = rp.en_objective
      card.impact       = rp.ru_impact
      card.en_impact    = rp.en_impact
      card.usage        = rp.ru_usage
      card.en_usage     = rp.en_usage
    end
    project.critical_technologies = rp.critical_technologies.map { |n| CriticalTechnology.find_by_name!(n) }
    project.direction_of_sciences = rp.directions_of_science.map { |n| DirectionOfScience.find_or_create_by_name!(n) }
    project.research_areas = rp.areas.map { |n| ResearchArea.find_by_name!(n) }
    project.save or raise project.errors.inspect
    redirect_to reports_migrator_path
  end
  
  def update
    OldReportProject.where(id: params[:id]).update_all(project_id: params[:project_id])
    redirect_to reports_migrator_path
  end
  
  def merge_projects
    p1 = Project.find(params[:p1])
    p2 = Project.find(params[:p2])
    p1.title.size > p2.title.size ? p1.merge(p2) : p2.merge(p1)
    redirect_to reports_migrator_path
  end
  
  def get_report
    get_reports.first
  end
  
  def get_reports
    ids = OldReport.where(state: 'assessed')
    OldReportProject.where(report_id: ids, project_id: nil).order('id')
  end
end

class OldReport < ActiveRecord::Base
  def user
    User.find(user_id)
  end
  
  def projects
    OldReportProject.where(report_id: id)
  end
end
class OldReportProject < ActiveRecord::Base
  serialize :critical_technologies
  serialize :directions_of_science
  serialize :areas
  
  def report
    OldReport.find(report_id)
  end
  
  def project
    Project.find(project_id)
  end
end
