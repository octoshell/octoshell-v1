class AddValidToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :filled, :boolean, default: true
    Project.all.each do |p|
      p.disabled = false; p.valid? || p.update_column(:filled, false)
    end
  end
end
