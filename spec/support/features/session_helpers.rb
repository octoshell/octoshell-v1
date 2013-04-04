# coding: utf-8
module Features
  module SessionHelpers
    def sign_in_with(email, password)
      visit root_path
      fill_in 'Email', with: email
      fill_in 'Пароль', with: password
      click_button 'Войти'
    end
  end
end