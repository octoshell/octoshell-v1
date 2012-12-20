class Report::Project < ActiveRecord::Base
  attr_accessible :ru_title, :ru_author, :ru_email, :ru_area, :ru_driver,
    :ru_strategy, :ru_objective, :ru_impact, :ru_usage, :en_title, :en_author,
    :en_email, :en_area, :en_driver, :en_strategy, :en_objective, :en_impact,
    :en_usage, :publications_count, :books_count, :vacs_count, :lectures_count,
    :international_conferences_count, :russian_conferences_count,
    :doctors_dissertations_count, :candidates_dissertations_count,
    :students_count, :rffi_grants_count, :ministry_of_communications_grants_count,
    :ran_grants_count, :other_russian_grants_count, :other_intenational_grants_count,
    :hours, :size, :full_power, :strict_schedule, :comment
end
