class NotificationsSender < Struct.new(:id)
  def perform
    Notification::Recipient.find(id).deliver!
  end
end
