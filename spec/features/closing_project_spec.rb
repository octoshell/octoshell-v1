# coding: utf-8
require 'spec_helper'

feature 'Closing Project' do
  scenario 'just created' do
    project = factory!(:project)
    sign_in project.user
    visit project_path(project)
    
    click_on 'завершить'
    click_on "Я действительно хочу завершить проект #{project.title}"
    
    expect(page).to have_content('Проект помечен для завершения')
  end
end
