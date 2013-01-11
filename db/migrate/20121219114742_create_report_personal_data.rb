class CreateReportPersonalData < ActiveRecord::Migration
  def change
    create_table :report_personal_data do |t|
      t.references :report
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :email
      t.string :phone
      t.string :confirm_data
    end
  end
end
