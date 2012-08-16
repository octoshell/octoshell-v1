class Reply < ActiveRecord::Base
  has_paper_trail
  
  has_attached_file :attachment
  
  delegate :answer!, :reply!, to: :ticket
  delegate :admin?, to: :user, prefix: true
  delegate :state_name, to: :ticket, prefix: true
  
  default_scope order(:id)
  
  belongs_to :user
  belongs_to :ticket
  
  validates :user, :ticket, :message, presence: true
  validates :ticket_state_name, exclusion: { in: [:closed] }, if: :ticket
  
  attr_accessible :message, :ticket_id, :attachment
  
  after_create :answer!, if: :user_admin?
  after_create :reply!, unless: :user_admin?
  after_create :notify_user, if: :user_admin?
  
  def attachment_image?
    attachment_content_type.to_s =~ /image/
  end
  
private
  
  def notify_user
    UserMailer.new_ticket_answer(ticket).deliver
  end
end
