def login(user)
  visit new_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: '123456'
  click_on 'session_submit'
end

def current_user
  User.find_by_email page.find('#user').text
end

