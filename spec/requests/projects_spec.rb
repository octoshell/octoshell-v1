require 'spec_helper'

shared_examples 'project creator' do
  it 'should create new project' do
    user.projects.should include(new_project)
  end

  it 'should create an account' do
    user.accounts.map(&:project).should include(new_project)
  end

  it 'should redirect to new request page' do
    current_path.should == new_request_path
  end
end

describe 'Projects', js: true do
  context 'as admin user' do
    context 'creating' do
      let!(:user) { create(:sured_user) }
      let!(:project) { build(:project, user: user) }
      let!(:cluster) { create(:cluster) }
    
      before do
        login create(:admin_user)
        visit new_project_path
        select user.full_name, from: 'User'
        select project.organization.name, from: 'Organization'
        fill_in 'Name',        with: project.name
        fill_in 'Description', with: project.description
        click_button 'Create Project'
      end
    
      def new_project
        Project.find_by_name(project.name)
      end
    
      it_behaves_like 'project creator'
    end
    
    context 'closing' do
      let!(:project) { create(:project) }
      let!(:cluster) { create(:cluster) }
      
      before do
        login create(:admin_user)
        visit project_path(project)
        click_link 'close'
        confirm_dialog
      end
      
      it { project.reload.should be_closed }
    end
  end
  
  context 'as user' do
    context 'creating' do
      let!(:user) { create(:sured_user) }
      let!(:project) { build(:project, user: user) }
      let!(:cluster) { create(:cluster) }
    
      before do
        login user
        visit new_project_path
        fill_in 'Name',        with: project.name
        fill_in 'Description', with: project.description
        select project.organization.name, from: 'Organization'
        click_button 'Create Project'
      end
    
      def new_project
        Project.find_by_name(project.name)
      end
      
      it_behaves_like 'project creator' 
    end
    
    context 'closing' do
      let!(:project) { create(:project) }
      let!(:user) { project.user }
      
      before do
        login user
        visit project_path(project)
        click_link 'close'
        confirm_dialog
      end
      
      it { project.reload.should be_closed }
    end
  end
  
  context 'non authorized user' do
    before { visit projects_path }
    
    it_behaves_like 'non authorized user'
  end
end
