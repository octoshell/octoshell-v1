require 'spec_helper'

describe 'Credentials', js: true do
  context 'as authotized user' do
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
  
  context 'as non authotized user' do
    before { visit new_credential_path }
    
    it 'should show new session page' do
      current_path.should == new_session_path
    end
  end
end
