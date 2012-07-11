require 'spec_helper'

describe 'Project' do
  context 'as authorized user' do
    let(:user) { create(:sured_user) }
    let(:project) { build(:project) }
    let!(:cluster) { create(:cluster) }
    
    before do
      login(user)
      visit new_project_path
      fill_in 'project_name', with: project.name
      select cluster.name, from: 'project_requests_attributes_0_cluster_id'
      fill_in 'project_requests_attributes_0_hours', with: 1
      click_button 'submit_project'
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
      current_path.should == dashboard_path
    end
  end
  
  context 'as non authorized user' do
    before { visit projects_path }
    it { current_path.should == new_session_path }
  end
end
