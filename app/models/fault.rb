class Fault < ActiveRecord::Base
  KINDS = [:report, :survey, :custom]
  
  belongs_to :user
  belongs_to :reference, polymorphic: true
  has_many :replies
  
  validates :user, presence: true
  validates :kind, inclusion: { in: KINDS.map(&:to_s) }
  
  after_create :block_accesses
  
  state_machine initial: :actual do
    state :actual
    state :resolved
    
    event :resolve do
      transition :actual => :resolved
    end
    
    inside_transition :on => :resolve, &:try_unblock_accesses
  end
  
  def block_accesses
    related_projects.each do |project|
      project.requests.with_state(:active).each &:block!
    end
    user.revalidate!
  end
  
  def related_projects
    user.owned_projects.with_state(:active)
  end
  
  def try_unblock_accesses
    if only_fault?
      related_projects.each do |project|
        project.requests.with_state(:blocked).each &:unblock!
      end
      user.revalidate!
    end
  end
  
  def only_fault?
    user.faults.with_state(:actual).count == 0
  end
  
  def kind
    self[:kind] ? self[:kind].to_s : nil
  end
end
