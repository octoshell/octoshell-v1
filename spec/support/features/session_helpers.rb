# coding: utf-8
module Features
  module SessionHelpers
    def sign_in_with(email, password)
      visit root_path
      fill_in 'Email', with: email
      fill_in 'Пароль', with: password
      click_button 'Войти'
    end
    
    def sign_in(user = nil)
      user ||= factory!(:user)
      sign_in_with user.email, '123456'
    end
    
    def shot!
      path = "/tmp/#{SecureRandom.hex}.png"
      page.save_screenshot path, full: true
      `open #{path}`
    end
  end
end