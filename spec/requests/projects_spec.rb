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
      let!(:fixture) { Fixture.new }
      let!(:project) { fixture.project }
      let!(:account) { fixture.account }
      let!(:request) { fixture.request }
      
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
  
  context 'as user' do
    context 'creating' do
      let!(:user) { create(:sured_user) }
      let(:project) { build(:project, user: user) }
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
      let!(:fixture) { Fixture.new }
      let!(:user)    { fixture.project.user }
      let!(:project) { fixture.project }
      let!(:account) { fixture.account }
      let!(:request) { fixture.request }
      
      before do
        login user
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
  
  context 'non authorized user' do
    before { visit projects_path }
    
    it_behaves_like 'non authorized user'
  end
end
