every 5.minutes do
  rake "counters:active_projects"
end

every 1.hour do
  rake "db:backup"
end
