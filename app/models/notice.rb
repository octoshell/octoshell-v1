class Notice < ActiveRecord::Base
  has_many :user_notices, class_name: :"User::Notice", dependent: :destroy
  
  attr_accessible :body, :subject, :start_at, :end_at, :url, as: :admin
  
  scope :active, -> {
    where("start_at <= :time and end_at >= :time", time: Time.zone.now)
  }
  
  def deliver
    user_notices.without_deliver_state(:delivered).each &:deliver!
  end
  
  def start_at=(date)
    if date.is_a?(String)
      self[:start_at] = Time.parse(date)
    else
      self[:start_at] = date
    end
  end
  
  def start_at
    self[:start_at] ? self[:start_at].to_date.to_s : nil
  end
  
  def end_at=(date)
    if date.is_a?(String)
      self[:end_at] = Time.parse(date)
    else
      self[:end_at] = date
    end
  end
  
  def end_at
    self[:end_at] ? self[:end_at].to_date.to_s : nil
  end
  
  def percentage
    total = user_notices.count
    viewed = user_notices.with_state(:viewed).count
    if total > 0
      ((viewed.to_f / total) * 100).round
    else
      0
    end
  end
  
  def active?
    now = Time.zone.now
    now >= start_at && now <= end_at
  end
  
  def remove_users
    user_notices.destroy_all
  end
  
  def add_users(ids)
    ids.each do |id|
      user_notices.where(user_id: id).first_or_create!
    end
  end
end
