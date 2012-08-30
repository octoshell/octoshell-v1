class TasksCallbacksWorker
  @queue = :task_requests
  
  def self.perform(id)
    Task.find(id).perform_callbacks!
  end
end
