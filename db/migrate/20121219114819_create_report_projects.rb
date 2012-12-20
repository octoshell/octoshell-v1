class CreateReportProjects < ActiveRecord::Migration
  def change
    create_table :report_projects do |t|
      t.references :report
      
      t.string :ru_title
      t.string :ru_author
      t.string :ru_email
      t.string :ru_area
      t.string :ru_driver
      t.string :ru_strategy
      t.string :ru_objective
      t.string :ru_impact
      t.string :ru_usage
      t.string :ru_lang

      t.string :en_title
      t.string :en_author
      t.string :en_email
      t.string :en_area
      t.string :en_driver
      t.string :en_strategy
      t.string :en_objective
      t.string :en_impact
      t.string :en_usage
      t.string :en_lang

      t.integer :publications_count
      t.integer :books_count
      t.integer :vacs_count
      t.integer :lectures_count

      t.integer :international_conferences_count
      t.integer :russian_conferences_count

      t.integer :doctors_dissertations_count
      t.integer :candidates_dissertations_count

      t.integer :students_count

      t.integer :rffi_grants_count
      t.integer :ministry_of_defence_grants_count
      t.integer :ros_nano_tech_grants_count
      t.integer :ministry_of_communications_grants_count
      t.integer :ran_grants_count
      t.integer :other_russian_grants_count
      t.integer :other_intenational_grants_count

      t.integer :awards_count
      t.string :award_names

      t.string :additional

      t.string :hours
      t.string :size
      t.string :full_power
      t.string :strict_schedule
      t.string :comment
    end
  end
end
