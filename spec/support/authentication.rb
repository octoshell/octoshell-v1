# coding: utf-8

def login(user = create(:user))
  visit new_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: '123456'
  click_button 'Войти'
end

def current_user
  User.find_by_email page.find('#user a').text
rescue Capybara::ElementNotFound
end

