require 'spec_helper'

describe 'Accounts', js: true do
  let!(:account) { create(:active_account) }
  
  describe 'listing' do
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
    
    context 'as account owner' do
      before do
        login account.user
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
  
  describe 'request' do
    context 'as admin' do
      let!(:user) { create(:sured_user) }
      let!(:project) { create(:project) }
      
      before do
        login create(:admin_user)
        visit new_account_path
        within('#new_account_request') do
          select user.full_name, from: 'User'
          select project.name, from: 'Project'
          click_button 'Request'
        end
      end
      
      it 'should mark account as requested' do
        Account.where(project_id: project.id, user_id: user.id).first.should be_requested
      end
    end
    
    context 'as sured user' do
      let!(:user) { create(:sured_user) }
      let!(:project) { create(:project) }
      
      before do
        login user
        visit new_account_path
        within('#new_account_request') do
          select project.name, from: 'Project'
          click_button 'Request'
        end
      end
      
      it 'should mark account as requested' do
        Account.where(project_id: project.id, user_id: user.id).first.should be_requested
      end
    end
  end
  
  describe 'invite' do
    context 'as admin' do
      let!(:user) { create(:sured_user) }
      let!(:project) { create(:project) }
      
      before do
        login create(:admin_user)
        visit new_account_path
        within('#new_account_invitation') do
          select user.full_name, from: 'User'
          select project.name, from: 'Project'
          click_button 'Invite'
        end
      end
      
      it 'should activate account' do
        Account.where(project_id: project.id, user_id: user.id).first.should be_active
      end
    end
    
    context 'as user' do
      let!(:user) { create(:sured_user) }
      let!(:project) { create(:project) }
      
      before do
        login project.user
        visit new_account_path
        within('#new_account_invitation') do
          select user.full_name, from: 'User'
          select project.name, from: 'Project'
          click_button 'Invite'
        end
      end
      
      it 'should activate account' do
        Account.where(project_id: project.id, user_id: user.id).first.should be_active
      end
    end
  end
  
  describe 'invite other', focus: true do
    context 'as admin' do
      let!(:project) { create(:project) }
      
      before do
        login create(:admin_user)
        visit new_account_path
        within('#new_account_batch_invitation') do
          select project.name, from: 'Project'
          fill_in 'Raw emails', with: 'user@example.com'
          click_button 'Invite'
        end
      end
      
      it 'should send email to user@example.com' do
        pending "it works"
        UserMailer.should_receive(:invitation).once
      end
    end
    
    context 'as user' do
      let!(:project) { create(:project) }
      
      before do
        login project.user
        visit new_account_path
        within('#new_account_batch_invitation') do
          select project.name, from: 'Project'
          fill_in 'Raw emails', with: 'user@example.com'
          click_button 'Invite'
        end
      end
      
      it 'should send email to user@example.com' do
        pending "it works"
        UserMailer.should_receive(:invitation).once
      end
    end
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
    
    context 'as account project owner' do
      before do
        login account.project.user
        visit account_path(account)
      end
      
      it 'should show account' do
        page.should have_css("#account-#{account.id}-detail")
      end
    end
    
    context 'as account owner' do
      before do
        login account.user
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
  
  describe 'closing' do
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
    
    context 'as account owner' do
      before do
        login account.project.user
        visit account_path(account)
        click_link 'cancel'
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
