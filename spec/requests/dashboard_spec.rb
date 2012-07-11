require 'spec_helper'

describe 'Dashboard' do
  let!(:user) { create(:user) }
  
  describe 'Requests' do
    let!(:project) { create(:project) }
    let!(:account) { create(:account, user: user, project: project) }
    let!(:requests) do
      10.times.map { create(:request, project: project, user: user) }
    end
    
    before do
      login user
      visit dashboard_path
    end
    
    it 'should show 5 last requests' do
      requests.last(5).each do |request|
        within('#requests') do
          page.should have_content(request.id)
          page.should have_link(request.project.name)
          page.should have_link(request.cluster.name)
          page.should have_content(request.human_state_name)
          page.should have_content(request.created_at.to_formatted_s(:short))
        end
      end
    end
    
    it 'should have a link to new request' do
      within('#requests') do
        page.should have_link(I18n.t 'pages.dashboard.new_request')
      end
    end
  end
  
  describe 'Projects' do
    let!(:user) { create(:user) }
    let!(:projects) { 3.times.map { create(:project, user: user) } }
    
    before do
      projects.each do |project|
        create(:account, user: user, project: project)
      end
      login user
      visit dashboard_path
    end
    
    it 'should should all projects' do
      projects.each do |project|
        within('#projects') do
          page.should have_content(project.id)
          page.should have_link(project.name)
        end
      end
    end
    
    it 'should have link to new projects' do
      within('#projects') do
        page.should have_link(I18n.t 'pages.dashboard.new_project')
      end
    end
  end
end
