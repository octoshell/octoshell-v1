class RenameGroupToGroupNumberAtPositionNames < ActiveRecord::Migration
  def change
    group_position = PositionName.find_by_name("Группа")
    group_position.update_column(:name, "Номер группы (для студентов МГУ)")
  end
end
