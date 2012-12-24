class AddAttachmentMaterialsToReportProjects < ActiveRecord::Migration
  def self.up
    change_table :report_projects do |t|
      t.has_attached_file :materials
    end
  end

  def self.down
    drop_attached_file :report_projects, :materials
  end
end
