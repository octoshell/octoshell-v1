class AddDefaultsToReportProjects < ActiveRecord::Migration
  def change
    change_table :report_projects do |t|
      t.change_default :books_count, 0
      t.change_default :vacs_count, 0
      t.change_default :lectures_count, 0
      t.change_default :international_conferences_count, 0
      t.change_default :russian_conferences_count, 0
      t.change_default :doctors_dissertations_count, 0
      t.change_default :candidates_dissertations_count, 0
      t.change_default :students_count, 0
      t.change_default :graduates_count, 0
      t.change_default :your_students_count, 0
      t.change_default :rffi_grants_count, 0
      t.change_default :ministry_of_education_grants_count, 0
      t.change_default :rosnano_grants_count, 0
      t.change_default :ministry_of_communications_grants_count, 0
      t.change_default :ministry_of_defence_grants_count, 0
      t.change_default :ran_grants_count, 0
      t.change_default :other_russian_grants_count, 0
      t.change_default :other_intenational_grants_count, 0
      t.change_default :lomonosov_intel_hours, 0
      t.change_default :lomonosov_nvidia_hours, 0
      t.change_default :chebyshev_hours, 0
      t.change_default :lomonosov_size, 0
      t.change_default :chebyshev_size, 0
    end
  end
end
