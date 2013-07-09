class Mailer < ActionMailer::Base
  include AbstractController::Callbacks
  
  default from: 'Octoshell Notifier <service@users.parallel.ru>',
          reply_to: 'service@users.parallel.ru'
  
  after_filter :log_sending
  
  def welcome(user)
    @user = user
    mail to: user.email, subject: 'Данные для пререгистрации на суперкомпьютерном комплексе МГУ'
  end
  
  def activation_needed_email(user)
    @user = user
    mail to: @user.emails, subject: 'Активация аккаунта'
  end
  
  def activation_success_email(user)
    @user = user
    mail to: @user.emails, subject: 'Активация в прошла успешно'
  end
  
  def reset_password_email(user)
    @user = user
    mail to: @user.emails, subject: 'Восстановление пароля'
  end
  
  def notify_new_organization(organization)
    @organization = organization
    @admin = true
    emails = User.admins.pluck(:email)
    mail to: emails, subject: 'Создана новая организация'
  end
  
  def invite(account_code)
    @account_code = account_code
    @project = @account_code.project
    @user = User.find_by_email(@account_code.email)
    mail to: @account_code.email, subject: %{Вас приглашают в работать над проектом "#{@project.title}"}
  end
  
  def new_ticket_answer(ticket)
    @ticket = ticket
    @user = @ticket.user
    mail to: @user.emails, subject: %{Новое сообщение от поддержки в заявке "#{@ticket.subject}"}
  end
  
  def fault_reply(user, reply)
    @user = user
    @reply = reply
    @fault = reply.fault
    mail to: @user.emails, subject: %{Новое сообщение в #{@fault.description}}
  end

  def report_reply(user, reply)
    @user = user
    @reply = reply
    mail to: @user.email, subject: %{Новое сообщение в отчете ##{reply.report_id}}
  end

  def project_blocked(account)
    @project = account.project
    @user = account.user
    mail to: @user.email, subject: subject(name: @project.title)
  end
  
  def notification(recipient)
    @user = recipient.user
    @body = recipient.notification.body
    mail to: @user.emails, subject: recipient.notification.title
  end
  
  def session_archive_is_ready(email, path)
    @url = root_url + path
    mail to: email, subject: "Архив перерегистрации подготовлен к загрузке"
  end
  
private

  def markdown(text)
    Redcarpet.new(text, :smart, :filter_html, :hard_wrap).to_html.html_safe
  end
  helper_method :markdown
  
  def log_sending
    if @user
      @user.delivered_mails.create_by_mail!(mail)
    end
  end
end