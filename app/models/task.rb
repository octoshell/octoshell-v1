class Task < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :resource, polymorphic: true
  
  validates :resource, presence: true
  
  state_machine :state, initial: :pending do
    state :pending
    state :complete
    state :failed
  end
end
