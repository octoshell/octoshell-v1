class CleanupReportPersonalSurveys < ActiveRecord::Migration
  def change
    change_table :report_personal_surveys do |t|
      t.change "software", :text
      t.change "technologies", :text
      t.change "compilators", :text
      t.change "learning", :text
      t.change "wanna_be_speaker", :text
      t.change "request_technology", :text
      t.change "other_technology", :text
      t.change "precision", :text
      t.change "other_compilator", :text
      t.change "other_software", :text
      t.change "other_learning", :text
    end
  end
end
