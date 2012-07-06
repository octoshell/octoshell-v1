class UserMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  
  def activation_needed_email(user)
    @user = user
    mail to: @user.email
  end
  
  def activation_success_email(user)
    @user = user
    mail to: @user.email
  end
  
  def reset_password_email(user)
    @user = user
    mail to: @user.email
  end
end