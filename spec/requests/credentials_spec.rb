require 'spec_helper'

describe 'Credentials', js: true do
  context 'as authotized user' do
    context 'creating' do
      before do
        login
        visit new_credential_path
        within('#new_credential') do
          fill_in 'Name', with: 'iMac'
          fill_in 'Public key', with: '=== tratata'
          click_button 'Create Credential'
        end
      end
    
      def new_credential
        current_user.credentials.where(public_key: '=== tratata').first
      end
    
      it 'should show profile page' do
        current_path.should == credential_path(new_credential)
      end
    
      it 'should create new credential for current user' do
        new_credential.should be
      end
    end
    
    context 'closing' do
      let!(:user) { create(:user) }
      let!(:credential) { create(:credential, user: user) }
      let!(:project) { create(:active_project, user: user) }
      let!(:account) { create(:active_account, user: user, project: project) }
      let!(:request) { create(:active_request, user: user, project: project) }
      let!(:cluster_user) { cu = project.cluster_users.first; cu.complete_activation!; cu }
      let!(:access) { project.cluster_users.first.accesses.first }
      
      before do
        login user
        visit credential_path(credential)
        click_link 'close'
        confirm_dialog
        sleep 0.5
      end
      
      it 'should close credential' do
        credential.reload.should be_closed
      end
    
      it 'should show credential page' do
        current_path.should == credential_path(credential)
      end
    
      it 'should close all accesses' do
        within("#access-#{access.id}") do
          page.should have_content('closing')
        end
      end
    end
  end
  
  context 'as non authotized user' do
    before { visit new_credential_path }
    
    it 'should show new session page' do
      current_path.should == new_session_path
    end
  end
end
