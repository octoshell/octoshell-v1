# coding: utf-8
class Mailer < ActionMailer::Base
  default from: 'Octoshell Notifier <noreply@super.parallel.ru>'

  def welcome(user)
    @user = user
    mail to: 'releu@me.com', subject: 'Данные для пререгистрации на суперкомпьютерном комплексе МГУ'
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
    mail to: User.admins.pluck(:email), subject: 'Создана новая организация'
  end
  
  def invite(account_code)
    @account_code = account_code
    @project = @account_code.project
    @user = User.find_by_email(@account_code.email)
    mail to: @account_code.email, subject: %{Вас приглашают в работать над проектом "#{@project.name}"}
  end
  
  def new_ticket_answer(ticket)
    @ticket = ticket
    @user = @ticket.user
    mail to: @user.emails, subject: %{Новое сообщение от поддержки в заявке "#{@ticket.subject}"}
  end
  
  def request_changed(request)
    @request = request
    @user = @request.project.owner
    mail to: @user.emails, subject: %{Статус заявки на доступы к для проекта #{@request.project.name} изменен}
  end
  
  def account_activated(account)
    @user = account.user
    @project = account.project
    mail to: @user.emails, subject: %{Получен доступ к проекту #{@project.name}}
  end
  
  def account_canceled(account)
    @user = account.project.user
    @requester = account.user
    @project = account.project
    mail to: @user.emails, subject: %{Доступ к проекту #{@project.name} закрыт}
  end

  def admin_notifications
    emails = User.admins.pluck(:email)
    @requests = Request.pending
    @tasks = Task.failed
    @sureties = Surety.pending
    @tickets = Ticket.active
    mail to: emails, subject: %{В Octoshell есть не обработанные оповещения}
  end
end