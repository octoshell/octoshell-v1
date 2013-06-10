# coding: utf-8
class Mailer < ActionMailer::Base
  default from: 'Octoshell Notifier <service@users.parallel.ru>',
          reply_to: 'service@users.parallel.ru'
          
  
  def notify_about_changing_project(login, project, user)
    @login = login
    @project = project
    @user = user
    mail to: user.email, subject: 'Изменения в проекте на суперкомпьютере "Ломоносов"'
  end
  
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
    emails = Rails.env.production? ? User.admins.pluck(:email) : ['releu@me.com']
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
  
  def request_changed(request)
    @request = request
    @user = @request.project.owner
    mail to: @user.emails, subject: %{Статус заявки на доступы к для проекта #{@request.project.title} изменен}
  end
  
  def account_activated(account)
    @user = account.user
    @project = account.project
    mail to: @user.emails, subject: %{Получен доступ к проекту #{@project.title}}
  end
  
  def account_canceled(account)
    @user = account.project.user
    @requester = account.user
    @project = account.project
    mail to: @user.emails, subject: %{Доступ к проекту #{@project.title} закрыт}
  end

  def admin_notifications
    emails = User.admins.pluck(:email)
    emails = ['releu@me.com'] unless Rails.env.production?
    @requests = Request.pending
    @tasks = Task.failed
    @sureties = Surety.pending
    @tickets = Ticket.active
    mail to: emails, subject: %{В Octoshell есть не обработанные оповещения}
  end

  def report_reply(user, reply)
    @user = user
    @reply = reply
    mail to: @user.email, subject: %{Новое сообщение в отчете ##{reply.report_id}}
  end

  def report_declined(report)
    @report = report
    mail to: @report.user.email, subject: %{Ваш отчет отклонен.}
  end

  def report_submitted(report)
    @report = report
    mail to: @report.user.email, subject: %{Пользователь отправил отчет ##{@report.id} на рассмотрение}
  end
  
  def project_blocked(account)
    @project = account.project
    @user = account.user
    mail to: @user.email, subject: subject(name: @project.title)
  end
  
  def failed_email(user)
    @user = user
    mail to: @user.email, subject: "Письмо о блокировке доступа"
  end
  
  def superviser_required(report, user)
    @report = report
    @user = user
    mail to: @user.email, subject: "Необходимо разрешение на подачу отчёта после срока"
  end
  
  def notify_about_allow_state(report)
    @report = report
    @user = report.user
    subject = @report.allowed? ? "Вам дали разрешение на подачу отчёта" : "Вам отказали в разрешении на подачу отчёта"
    mail to: @user.email, subject: subject
  end
  
  def notification(recipient)
    @user = recipient.user
    @body = recipient.notification.body
    mail to: @user.emails, subject: recipient.notification.title
  end
  
  def notify_about_crash(user)
    @user = user
    mail to: @user.emails, subject: "Cроки открытия доступа на СК Ломоносов"
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
  
  def subject(options = {})
    mail = caller[0][/`.*'/][1..-2]
    t("mailer.#{mail}.subject", options)
  end
end