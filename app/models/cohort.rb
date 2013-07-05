class Cohort < ActiveRecord::Base
  KINDS = [ :organizations_by_kind,
            :projects_by_organization_kind,
            :projects_by_msu_subdivisions,
            :users_by_organization_kind,
            :users_by_msu_subdivisions,
            :directions_of_science,
            :directions_of_science_by_msu_subdivisions,
            :research_areas,
            :research_areas_by_msu_subdivisions,
            :critical_technologies,
            :critical_technologies_by_msu_subdivisions ]
  
  KINDS.each do |kind|
    scope kind, where(kind: kind).order("date desc")
  end
  
  before_create :set_date
  
  serialize :data
  
  def self.dump
    transaction do
      KINDS.each do |kind|
        new { |c| c.kind = kind }.dump
      end
    end
  end
  
  def self.human_kind_name(kind)
    I18n.t("cohorts.#{kind}")
  end
  
  def dump
    self.data = send("#{kind}_data")
    save!
  end
  
  def self.to_chart
    chart = []
    if head = scoped.first
      chart << ["Дата"].push(*head.data.map { |c| c[1] })
      scoped.map do |c|
        chart << [c.pub_date].push(*c.to_row)
      end
    end
    chart
  end
  
  def self.to_charts
    charts = {}
    scoped.each do |cohort|
      cohort.data.each do |group|
        charts[group[1]] ||= [["Дата"].push(*group[2].map { |d| d[1] })]
        datas = group[2].map { |d| d[2] }
        charts[group[1]] << [cohort.pub_date].push(*datas)
      end
    end
    charts
  end
  
  def pub_date
    date.strftime("%b %Y")
  end
  
  def to_row
    data.map { |row| row[2] }
  end
  
  private
  def organizations_by_kind_data
    OrganizationKind.all.map do |kind|
      [kind.id, kind.name, kind.organizations.with_state(:active).count]
    end
  end
  
  def projects_by_organization_kind_data
    OrganizationKind.all.map do |kind|
      count = Project.with_state(:active).joins(:organization).
        where(organizations: { state: "active", organization_kind_id: kind.id }).
        count
      [kind.id, kind.name, count]
    end
  end
  
  def projects_by_msu_subdivisions_data
    Organization.msu.subdivisions.order("name").map do |sub|
      count = Project.with_state(:active).joins(user: :memberships).
        where(memberships: { state: :active, subdivision_id: sub.id }).count
      [sub.id, sub.name, count]
    end
  end
  
  def users_by_organization_kind_data
    OrganizationKind.all.map do |kind|
      count = User.joins(memberships: :organization).with_state(:sured).
        where(organizations: { organization_kind_id: kind.id}).
        where(memberships: { state: "active" }).count
      [kind.id, kind.name, count]
    end
  end
  
  def users_by_msu_subdivisions_data
    Organization.msu.subdivisions.order("name").map do |sub|
      count = User.joins(:memberships).with_state(:sured).
        where(memberships: { state: "active", subdivision_id: sub.id }).count
      [sub.id, sub.name, count]
    end
  end
  
  def directions_of_science_data
    DirectionOfScience.all.map do |dir|
      count = Project.joins("join direction_of_sciences_projects on direction_of_sciences_projects.project_id = projects.id and direction_of_sciences_projects.direction_of_science_id = #{dir.id}").
        count
      
      [dir.id, dir.name, count]
    end
  end
  
  def directions_of_science_by_msu_subdivisions_data
    DirectionOfScience.all.map do |dir|
      map = Organization.msu.subdivisions.order("name").map do |sub|
        count = Project.joins("join direction_of_sciences_projects on direction_of_sciences_projects.project_id = projects.id and direction_of_sciences_projects.direction_of_science_id = #{dir.id}").
          joins(user: :memberships).where(memberships: { subdivision_id: sub.id }).
          count
        
        [sub.id, sub.name, count]
      end
      
      [dir.id, dir.name, map]
    end
  end
  
  def research_areas_data
    ResearchArea.all.map do |area|
      count = Project.joins("join projects_research_areas on projects_research_areas.project_id = projects.id and projects_research_areas.research_area_id = #{area.id}").
        count
      
      [area.id, area.name, count]
    end
  end
  
  def research_areas_by_msu_subdivisions_data
    ResearchArea.all.map do |area|
      map = Organization.msu.subdivisions.order("name").map do |sub|
        count = Project.joins("join projects_research_areas on projects_research_areas.project_id = projects.id and projects_research_areas.research_area_id = #{area.id}").
          joins(user: :memberships).where(memberships: { subdivision_id: sub.id }).
          count
        
        [sub.id, sub.name, count]
      end
      
      [area.id, area.name, map]
    end
  end
  
  def critical_technologies_data
    CriticalTechnology.all.map do |tech|
      count = Project.joins("join critical_technologies_projects on critical_technologies_projects.project_id = projects.id and critical_technologies_projects.critical_technology_id = #{tech.id}").
        count
      
      [tech.id, tech.name, count]
    end
  end
  
  def critical_technologies_by_msu_subdivisions_data
    CriticalTechnology.all.map do |tech|
      map = Organization.msu.subdivisions.order("name").map do |sub|
        count = Project.joins("join critical_technologies_projects on critical_technologies_projects.project_id = projects.id and critical_technologies_projects.critical_technology_id = #{tech.id}").
          joins(user: :memberships).where(memberships: { subdivision_id: sub.id }).
          count
        
        [sub.id, sub.name, count]
      end
      
      [tech.id, tech.name, map]
    end
  end
  
  def set_date
    self.date = Date.current
  end
end
