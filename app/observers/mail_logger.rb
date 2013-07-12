# Логгер отправленных сообщений
class MailLogger
  def self.delivered_email(mail)
    if mail[:user_id]
      user = User.find(mail[:user_id].value)
      user.delivered_mails.create_by_mail!(mail)
    end
  end
end
