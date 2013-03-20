module Models
  module MarkableForTask
    extend ActiveSupport::Concern
    
    def mark_for_task!
      if task_needed?
        raise ActiveRecord::RecordInProcess
      else
        self.task_needed = true
        save!
      end
    end
    
    def unmark_for_task!
      self.task_needed = false
      save!
    end
  end
end
