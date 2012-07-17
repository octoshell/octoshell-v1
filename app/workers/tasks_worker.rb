class TasksWorker
  @queue = :tasks
  
  def self.perform(task_id)
    Task.find(task_id).perform
  end
end
