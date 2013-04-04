require 'spec_helper'

feature 'Sign up', js: true do
  scenario 'with valid data' do
    visit new_user_path
    fill_in 'Email', with: 'email@example.com'
    fill_in 'Пароль', with: '123456'
    fill_in 'Подтверждение', with: '123456'
    fill_in 'Фамилия', with: 'Бернс'
    fill_in 'Имя', with: 'Чарльз'
    fill_in 'Отчество', with: 'Монтгомери'
    fill_in 'Номер телефона', with: '000'
    click_on 'Зарегистрироваться'
    expect(page).to have_content('На ваш email email@example.com отправлена инструкция по активации аккаунта.')
  end
end
