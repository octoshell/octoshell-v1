# DJ воркер для обновления когорт (новый срез)
class CohortUpdater
  def perform
    Cohort::KINDS.each { |k| c = Cohort.new; c.kind = k; c.dump }
  end
end
