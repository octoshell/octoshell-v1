class CreateReportPersonalSurveys < ActiveRecord::Migration
  def change
    create_table :report_personal_surveys do |t|
      t.references :report
      t.string :software
      t.string :technologies
      t.string :compilators
      t.string :learning
      t.string :wanna_be_speaker
    end
  end
end
