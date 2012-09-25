require 'spec_helper'

describe 'Accounts', js: true do
  let!(:account) { create(:active_account) }
  
  describe 'listing' do
    
  end
  
  describe 'show' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit account_path(account)
      end
      
      it 'should show account' do
        page.should have_css("#account-#{account.id}-detail")
      end
    end
    
    context 'as non authorized user' do
      before do
        visit account_path(account)
      end
      
      it 'should redirect to login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'canceling' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit account_path(account)
        click_link 'cancel'
        confirm_dialog
      end
      
      it 'should cancel account' do
        account.reload.should be_closed
      end
    end
    
    context 'as non authorized user' do
      before do
        visit account_path(account)
      end
      
      it 'should redirect to login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'updating' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit edit_account_path(account)
        fill_in 'Username', with: 'god'
        click_button 'Update Account'
      end
      
      it 'should update account' do
        account.reload.username.should == 'god'
      end
    end
    
    context 'as user' do
      before do
        login
        visit edit_account_path(account)
      end
      
      it 'should show dashboard' do
        current_path.should == dashboard_path
      end
    end
  end
end
