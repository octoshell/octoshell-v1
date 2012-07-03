require 'spec_helper'

describe 'Project Management' do
  context 'as authorized user' do
    let(:user) { create(:user) }
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
    
    it 'should create new project' do
      Project.find_by_name(project.name).should be
    end
    
    it 'should redirect to confirmation request page' do
      request = Project.find_by_name(project.name).requests.first
      current_path.should == request_confirmation_path(request)
    end
  end
  
  context 'as non authorized user' do
    before { visit projects_path }
    it { current_path.should == new_session_path }
  end
end
