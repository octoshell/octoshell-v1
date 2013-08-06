ActionMailer::Base.register_observer MailLogger

class Mailer < ActionMailer::Base
  default from: 'Octoshell Notifier <service@users.parallel.ru>',
          reply_to: 'service@users.parallel.ru'
  
  def activation_needed_email(user)
    @user = user
    m = mail to: @user.emails, subject: 'Активация аккаунта', user_id: @user.id
  end
  
  def activation_success_email(user)
    @user = user
    mail to: @user.emails, subject: 'Активация в прошла успешно', user_id: @user.id
  end
  
  def reset_password_email(user)
    @user = user
    mail to: @user.emails, subject: 'Восстановление пароля', user_id: @user.id
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
    mail to: @account_code.email, subject: %{Вас приглашают в работать над проектом "#{@project.title}"}, user_id: @user.id
  end
  
  def new_ticket_answer(user, ticket)
    @ticket = ticket
    @user = user
    mail to: @user.emails, subject: %{Новое сообщение от поддержки в заявке "#{@ticket.subject}"}, user_id: @user.id
  end
  
  def new_ticket(ticket, user)
    @ticket = ticket
    @user = user
    mail to: @user.emails, subject: %{Новая заявка в поддержку}, user_id: @user.id
  end
  
  def fault_reply(user, reply)
    @user = user
    @reply = reply
    @fault = reply.fault
    mail to: @user.emails, subject: %{Новое сообщение в #{@fault.description}}, user_id: @user.id
  end

  def report_reply(user, reply)
    @user = user
    @reply = reply
    mail to: @user.email, subject: %{Новое сообщение в отчете ##{reply.report_id}}, user_id: @user.id
  end

  def project_blocked(account)
    @project = account.project
    @user = account.user
    mail to: @user.email, subject: "Проект #{@project.title} заблокирован", user_id: @user.id
  end
  
  def notification(recipient)
    @user = recipient.user
    @body = recipient.notification.body
    mail to: @user.emails, subject: recipient.notification.title, user_id: @user.id
  end
  
  def session_archive_is_ready(email, path)
    @url = root_url + path
    mail to: email, subject: "Архив перерегистрации подготовлен к загрузке"
  end
  
  def report_assessed(report)
    @user = report.user
    @report = report
    mail to: @user.emails, subject: "Эксперт оценил ваш отчет ##{report.id}"
  end
  
  def report_rejected(report)
    @user = report.user
    @report = report
    mail to: @user.emails, subject: "Эсперт вернул вам отчет ##{report.id}"
  end
  
  def report_resubmitted(report)
    @user = report.expert
    @report = report
    mail to: @user.emails, subject: "Обновлен архив в отчете ##{report.id}"
  end
  
  def welcome_imported_user(id)
    @user = User.find(id)
    mail to: @user.emails, subject: "Вас зарегистрировали в Octoshell"
  end
  
  def notice(un)
    @user = un.user
    @un = un
    @notice = un.notice
    mail to: @user.emails, subject: @notice.subject
  end
  
private

  def markdown(text)
    Redcarpet.new(text, :smart, :filter_html, :hard_wrap).to_html.html_safe
  end
  helper_method :markdown
end
