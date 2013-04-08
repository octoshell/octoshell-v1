# coding: utf-8
require 'spec_helper'

feature 'Add member to Project', js: true do
  let!(:project) { create(:project) }
  let!(:new_user) { create(:sured_user) }
  
  before do
    sign_in project.user
    visit project_path(project)
  end
  
  scenario 'with surety' do
    click_on 'Добавить участника'
    shot!
  end
  
  scenario 'without surety'
  scenario 'by group with and without surety'
end
