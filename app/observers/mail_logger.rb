# Логгер отправленных сообщений
class MailLogger
  def self.delivered_email(mail)
    if mail[:user_id] && mail[:user_id].value.present?
      user = User.find(mail[:user_id].value)
      user.delivered_mails.create_by_mail!(mail)
    end
  end
end
