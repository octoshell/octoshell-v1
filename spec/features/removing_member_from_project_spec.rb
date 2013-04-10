require 'spec_helper'

feature 'Removing Member from Project', js: true do
  scenario 'persisted user' do
    project = factory!(:project)
    member = factory!(:user)
    surety = factory!(:surety, project: project)
    factory!(:surety_member, user: member, surety: surety)
    surety.generate!
    surety.activate!
    
    sign_in project.user
    visit project_path(project)
    
    find(:role, 'remove-member').click
    expect(page).to_not have_content(member.full_name)
  end
  
  scenario 'invited user' do
    project = factory!(:project)
    surety = factory!(:surety, project: project)
    member = factory!(:new_surety_member, surety: surety)
    surety.generate!
    surety.activate!
    
    sign_in project.user
    visit project_path(project)
    
    find(:role, 'remove-member').click
    expect(page).to_not have_content(member.full_name)
  end
end

