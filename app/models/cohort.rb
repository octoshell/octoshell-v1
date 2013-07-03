class Cohort < ActiveRecord::Base
  KINDS = [:organizations_by_kind]
  
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
    chart << ["Дата"].push(*scoped.first.data.map { |c| c[1] })
    scoped.map do |c|
      chart << [c.date.strftime("%b %Y")].push(*c.to_row)
    end
    chart
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
  
  def set_date
    self.date = Date.current
  end
end
