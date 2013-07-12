# DJ воркер. Отправляет нотификацию пользователю
class NotificationsSender < Struct.new(:id)
  def perform
    Notification::Recipient.find(id).deliver!
  end
end
