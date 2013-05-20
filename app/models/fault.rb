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
  end
  
  def block_accesses
    user.owned_projects.with_state(:active).each do |project|
      project.requests.with_state(:active).each &:block!
    end
    user.revalidate!
  end
  
  def kind
    self[:kind] ? self[:kind].to_s : nil
  end
end
