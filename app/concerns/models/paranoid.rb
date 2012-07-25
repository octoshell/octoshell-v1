module Models
  module Paranoid
    extend ActiveSupport::Concern
    
    def deleted?
      !!deleted_at
    end
    
    def mark_deleted
      self.deleted_at = Time.now
      save
    end
  end
end
