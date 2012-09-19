# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: 'Octoshell Notifier <noreply@v1.parallel.ru>'
  
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
  
  def invitation(account)
    @project = account.project
    mail to: account.emails, subject: %{Вас приглашают в работать над проектом "#{@project.name}"}
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
  
  def account_requested(account)
    @user = account.project.user
    @requester = account.user
    @project = account.project
    mail to: @user.emails, subject: %{#{@requester.full_name} запрашивает доступ к проекту #{@project.name}}
  end
  
  def account_declined(account)
    @user = account.project.user
    @requester = account.user
    @project = account.project
    mail to: @user.emails, subject: %{Отказ в доступе к проекту #{@project.name}}
  end
  
  def account_canceled(account)
    @user = account.project.user
    @requester = account.user
    @project = account.project
    mail to: @user.emails, subject: %{Доступ к проекту #{@project.name} закрыт}
  end
end