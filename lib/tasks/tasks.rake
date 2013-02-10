namespace :tasks do
  task :create_tickets => :environment do
    sql = %{
      SELECT "tasks".* FROM "tasks"
      INNER JOIN "tickets" ON "tickets"."resource_id" != "tasks"."id"
        AND "tickets"."resource_type" = 'Task' AND "tasks"."state" = 'failed'
      ORDER BY tasks.id desc
    }
    Task.find_by_sql(query).each do |t|
      t.create_failure_ticket!
    end
  end
end
