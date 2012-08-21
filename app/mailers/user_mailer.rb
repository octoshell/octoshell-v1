# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: 'Octoshell Notifier <noreply@octoshell.ru>'
  
  def activation_needed_email(user)
    @user = user
    mail to: @user.email, subject: 'Активация аккаунта'
  end
  
  def activation_success_email(user)
    @user = user
    mail to: @user.email, subject: 'Активация в прошла успешно'
  end
  
  def reset_password_email(user)
    @user = user
    mail to: @user.email, subject: 'Восстановление пароля'
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
    mail to: @user.email, subject: %{Новое сообщение от поддержки в заявке "#{@ticket.subject}"}
  end
  
  def request_changed(request)
    @request = request
    @user = @request.project.owner
    mail to: @user.email, subject: %{Статус заявки на доступы к для проекта #{@request.project.name} изменен}
  end
end