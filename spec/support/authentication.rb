def login(user = create(:user))
  visit new_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: '123456'
  click_button I18n.t('pages.shared.login')
end

def current_user
  User.find_by_email page.find('#user a').text
rescue Capybara::ElementNotFound
end

