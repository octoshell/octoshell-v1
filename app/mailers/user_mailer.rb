# coding: utf-8
class UserMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  
  def activation_needed_email(user)
    @user = user
    mail to: @user.email, subject: 'Активация аккаунта в "Название"'
  end
  
  def activation_success_email(user)
    @user = user
    mail to: @user.email, subject: 'Активация в "Название" прошла успешно'
  end
  
  def reset_password_email(user)
    @user = user
    mail to: @user.email, subject: 'Восстановление пароля в "Название"'
  end
  
  def notify_new_organization(organization)
    @organization = organization
    mail to: User.admins.pluck(:email), subject: 'Создана новая организация в "Название"'
  end
  
  def invitation(account)
    @project = account.project
    mail to: account.emails, subject: %{Вас приглашают в "Название" работать над проектом "#{@project.name}"}
  end
end