require 'spec_helper'

describe 'Requests' do
  context 'as authorized user', js: true do
    let!(:user) { create(:sured_user) }
    let!(:project) { create(:project, user: user) }
    let!(:cluster) { create(:cluster) }
    
    before do
      login user
      visit new_request_path
      
      within('#new_request') do
        select project.name, from: 'Project'
        select cluster.name, from: 'Cluster'
        fill_in 'Hours', with: 10
        fill_in 'Size', with: 10
        click_button 'Create Request'
      end
    end
    
    it 'should redirect to dashboard_path' do
      current_path.should == request_path(Request.last)
    end
  end
  
  context 'as admin user' do
    context 'listing' do
      let!(:requests) { 3.times.map { create(:request) } }
      
      before do
        login create(:admin_user)
        visit requests_path
      end
      
      it 'should show requests' do
        requests.each do |request|
          page.should have_css("#request-#{request.id}")
        end
      end
    end
    
    context 'creating' do
      let!(:user) { create(:user) }
      let!(:project) { create(:project, user: user) }
      let!(:cluster) { create(:cluster) }
      let!(:request) { build(:request, user: user) }
      
      before do
        login create(:admin_user)
        visit new_request_path
        
        within('#new_request') do
          select user.full_name, from: 'User'
          select project.name,   from: 'Project'
          select cluster.name,   from: 'Cluster'
          fill_in 'Hours', with: 10
          fill_in 'Size', with: 10
          click_button 'Create Request'
        end
      end
      
      it 'should create new request for user' do
        request.user.should have(1).requests
      end
    end
    
    context 'activing' do
      let!(:request) { create(:request) }
      
      before do
        login create(:admin_user)
        visit request_path(request)
        click_link('activate')
      end
      
      it 'should activate request' do
        within("#request-#{request.id}-status") do
          page.should have_content('active')
        end
      end
      
      it 'should create a cluster user' do
        within "#cluster-user-#{request.cluster_users.last.id}" do
          page.should have_content('activing')
        end
      end
    end
    
    context 'declining' do
      let!(:request) { create(:request) }
      
      before do
        login create(:admin_user)
        visit request_path(request)
        click_link('decline')
      end
      
      it 'should decline request' do
        within("#request-#{request.id}-status") do
          page.should have_content('declined')
        end
      end
    end
    
    context 'closing' do
      let!(:request) { create(:active_request) }
      
      before do
        login create(:admin_user)
        visit request_path(request)
        request.cluster_users.last.complete_activation!
        click_link('close')
      end
      
      it 'should decline request' do
        within("#request-#{request.id}-status") do
          page.should have_content('closed')
        end
      end
      
      it 'should close cluster user' do
        within "#cluster-user-#{request.cluster_users.last.id}" do
          page.should have_content('pausing')
        end
      end
    end
  end
end
