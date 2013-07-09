class Fault < ActiveRecord::Base
  KINDS = [:report, :survey, :custom, :project, :account]
  KINDS_OF_BLOCK = [:user, :account, :project]
  
  belongs_to :user
  has_many :replies
  
  validates :user, presence: true
  validates :kind, inclusion: { in: KINDS.map(&:to_s) }
  validates :kind_of_block, inclusion: { in: KINDS_OF_BLOCK.map(&:to_s) }
  
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
    send "block_accesses_for_#{kind_of_block}"
  end
  
  def block_accesses_for_project
    reference.requests.with_state(:active).each &:block!
  end
  
  def block_accesses_for_account
    reference.active? and reference.close!
  end
  
  def block_accesses_for_user
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
      send "unblock_accesses_for_#{kind_of_block}"
    end
  end
  
  def unblock_accesses_for_project
    reference.requests.with_state(:blocked).each &:unblock!
  end
  
  def unblock_accesses_for_account
    reference.activate
  end
  
  def unblock_accesses_for_user
    related_projects.each do |project|
      project.requests.with_state(:blocked).each &:unblock!
    end
    user.revalidate!
  end
  
  def only_fault?
    user.faults.where(kind_of_block: kind_of_block).
      with_state(:actual).count == 0
  end
  
  def reference
    send "#{kind}_reference"
  end
  
  def project_reference
    Project.find(reference_id)
  end
  
  def account_reference
    Account.find(reference_id)
  end
  
  def kind
    self[:kind] ? self[:kind].to_s : nil
  end
  
  def kind_of_block
    self[:kind_of_block] ? self[:kind_of_block].to_s : nil
  end
  
  def description
    self[:description].present? ? self[:description] : "без описания"
  end
end
