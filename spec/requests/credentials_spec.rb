require 'spec_helper'

describe 'Credentials' do
  context 'as authotized user' do
    before do
      login
      visit new_credential_path
      within('#new_credential') do
        fill_in 'credential_name', with: 'iMac'
        fill_in 'credential_public_key', with: '=== tratata'
        click_button I18n.t('pages.new_credential.create')
      end
    end
    
    it 'should show profile page' do
      current_path.should == profile_path
    end
    
    it 'should create new credential for current user' do
      current_user.credentials.where(public_key: '=== tratata').count.should == 1
    end
  end
  
  context 'as non authotized user' do
    before { visit new_credential_path }
    
    it 'should show new session page' do
      current_path.should == new_session_path
    end
  end
end
