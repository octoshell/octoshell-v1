# coding: utf-8

require 'spec_helper'

feature 'Create request', js: true do
  let!(:cluster) { factory!(:cluster) }
  let!(:project) { factory!(:project) }
  
  scenario 'with valid data' do
    sign_in project.user
    visit project_path(project)
    click_on 'Создать заявку'
    within '.popover' do
      fill_in 'CPU-часы', with: '10'
      fill_in 'Размер, GB', with: '10'
      click_button 'Создать'
    end
    expect(page).to have_content('Заявка создана')
  end
end