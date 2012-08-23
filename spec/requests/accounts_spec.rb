require 'spec_helper'

describe 'Accounts', js: true do
  let!(:account) { create(:active_account) }
  
  context 'listing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit accounts_path
      end
      
      it 'should show account' do
        page.should have_css("#account-#{account.id}")
      end
    end
    
    context 'as account owner' do
      before do
        login account.project.user
        visit accounts_path
      end
      
      it 'should show account' do
        page.should have_css("#account-#{account.id}")
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
  
  context 'show' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit account_path(account)
      end
      
      it 'should show account' do
        page.should have_css("#account-#{account.id}-detail")
      end
    end
    
    context 'as account owner' do
      before do
        login account.project.user
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
  
  context 'closing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit account_path(account)
        click_link 'close'
        confirm_dialog
      end
      
      it 'should close account' do
        account.reload.should be_closed
      end
    end
    
    context 'as account owner' do
      before do
        login account.project.user
        visit account_path(account)
        click_link 'close'
        confirm_dialog
      end
      
      it 'should close account' do
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
end
