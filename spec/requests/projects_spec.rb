require 'spec_helper'

describe 'Projects', js: true do
  context 'as admin user' do
    context 'creating' do
      let!(:user) { create(:sured_user) }
      let(:project) { build(:project, user: user) }
      let!(:cluster) { create(:cluster) }
    
      before do
        login create(:admin_user)
        visit new_project_path
        select user.full_name, from: 'User'
        fill_in 'Name',        with: project.name
        fill_in 'Description', with: project.description
        select cluster.name, from: 'Cluster'
        fill_in 'Hours', with: 1
        fill_in 'Size',  with: 1
        click_button 'Create Project'
      end
    
      def new_project
        Project.find_by_name(project.name)
      end
    
      it 'should create new project' do
        user.projects.should include(new_project)
      end
    
      it 'should create an account' do
        user.accounts.map(&:project).should include(new_project)
      end
    
      it 'should create a request' do
        new_project.should have(1).requests
      end
    
      it 'should redirect to dashboard page' do
        current_path.should == project_path(new_project)
      end
    end
    
    context 'closing' do
      let!(:project) { create(:active_project) }
      let!(:account) { create(:active_account, project: project) }
      let!(:request) { create(:active_request, project: project, user: project.user) }
      
      before do
        login create(:admin_user)
        visit project_path(project)
        click_link 'close'
        confirm_dialog
        sleep 1
      end
      
      it { project.reload.should be_closed }
      it { account.reload.should be_closed }
      it { request.reload.should be_closed }
    end
  end
  
  context 'as non authorized user' do
    before { visit projects_path }
    it { current_path.should == new_session_path }
  end
end
