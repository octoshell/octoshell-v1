class Report < ActiveRecord::Base
  belongs_to :session
  belongs_to :project
  
  state_machine :state, initial: :pending do
    state :pending
    state :accepted
    state :submitted
    state :assessing
    state :assessed
    state :declined
    
    event :accept do
      transition [:pending, :declined] => :accepted
    end
    
    event :submit do
      transition :accepted => :submitted
    end
    
    event :pick do
      transition :submitted => :assessing
    end
    
    event :assess do
      transition :assessing => :assessed
    end
    
    event :decline do
      transition :assessing => :declined
    end
  end
end
