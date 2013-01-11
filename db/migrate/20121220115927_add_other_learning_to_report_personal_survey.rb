class AddOtherLearningToReportPersonalSurvey < ActiveRecord::Migration
  def change
    add_column :report_personal_surveys, :other_learning, :string
  end
end
