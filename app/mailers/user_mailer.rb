# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: 'noreply@octoshell.ru'
  
  def activation_needed_email(user)
    @user = user
    mail to: @user.email, subject: 'Активация аккаунта в OctoShell'
  end
  
  def activation_success_email(user)
    @user = user
    mail to: @user.email, subject: 'Активация в OctoShell прошла успешно'
  end
  
  def reset_password_email(user)
    @user = user
    mail to: @user.email, subject: 'Восстановление пароля в OctoShell'
  end
  
  def notify_new_organization(organization)
    @organization = organization
    mail to: User.admins.pluck(:email), subject: 'Создана новая организация в OctoShell'
  end
  
  def invitation(account)
    @project = account.project
    mail to: account.emails, subject: %{Вас приглашают в OctoShell работать над проектом "#{@project.name}"}
  end
  
  def new_ticket_answer(ticket)
    @ticket = ticket
    mail to: ticket.user.email, subject: %{Новое сообщение от поддержки в заявке "#{@ticket.subject}"}
  end
end