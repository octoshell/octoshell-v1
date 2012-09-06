require 'spec_helper'

describe 'Requests', js: true do
  context 'as authorized user' do
    describe 'creation' do
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
    
      it 'should redirect to request path' do
        current_path.should == request_path(Request.last)
      end
    end
  end
  
  context 'as admin user' do
    context 'listing' do
      let!(:request) { Fixture.request }
      
      before do
        login create(:admin_user)
        visit requests_path
      end
      
      it 'should show requests' do
        page.should have_css("#request-#{request.id}")
      end
    end
    
    context 'creating' do
      let!(:fixture) { Fixture.new }
      let!(:user) { fixture.project.user }
      let!(:project) { fixture.project }
      let!(:cluster) { fixture.cluster }
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
        user.should have(2).requests
      end
    end
    
    context 'activing' do
      let!(:request) { Fixture.request }
      
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
    end
    
    context 'declining' do
      let!(:request) { Fixture.request }
      
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
    
    context 'closing', focus: true do
      let!(:request) { Fixture.active_request }
      
      before do
        login create(:admin_user)
        visit request_path(request)
        click_link('close')
      end
      
      it 'should decline request' do
        within("#request-#{request.id}-status") do
          page.should have_content('closed')
        end
      end
      
      it 'should close cluster project' do
        within "#cluster-project-#{request.cluster_project_id}" do
          page.should have_content('pausing')
        end
      end
    end
    
    context 'updating' do
      let!(:request) { Fixture.request }
      let!(:request_property) { create(:request_property, name: 'Foo', request: request) }
      
      before do
        login create(:admin_user)
        visit edit_request_path(request)
        fill_in 'Foo', with: 'Moo'
        click_button 'Update Request'
      end
      
      it 'should update request property' do
        request_property.reload.value.should == 'Moo'
      end
    end
  end
end
