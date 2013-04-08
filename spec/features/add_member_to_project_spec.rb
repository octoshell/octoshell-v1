# coding: utf-8
require 'spec_helper'

Capybara.add_selector(:role) do
  css { |role| "[role='#{role}']" }
end

feature 'Add member to Project', js: true do
  let!(:project) { create(:project) }
  let!(:new_user) { create(:sured_user) }
  
  before do
    sign_in project.user
    visit project_path(project)
  end
  
  scenario 'with surety' do
    click_link 'Добавить участников'
    page.execute_script %{
      var controller = $('@project-members-controller');
      controller.val('#{new_user.last_name.first(3)}');
      controller.keyup();
    }
    sleep 0.5
    page.execute_script %{
      var controller = $('@project-members-controller');
      var e = $.Event('keyup');
      e.keyCode = 13;
      controller.trigger(e);
    }
    sleep 0.5
    click_button 'Добавить участников'
    expect(page).to have_content('Участники добавлены')
  end
  
  scenario 'without surety'
  scenario 'by group with and without surety'
end
