# coding: utf-8
require 'spec_helper'

feature 'Visitor signs up', js: true do
  scenario 'with valid data' do
    user = factory(:user)
    sign_in_with user.email, '123456'
    expect(page).to have_content('Выход')
  end
end
