require 'spec_helper'

describe 'Memberships', js: true do
  describe 'creating' do
    let!(:organization) { create(:organization) }
    let!(:position_name) { create(:position_name) }
    let!(:user) { create(:user) }
    
    before do
      login user
      visit new_membership_path
      select organization.name, from: 'Organization'
      fill_in position_name.name, with: 'value'
      click_button 'Create Membership'
    end
    
    it 'should create a membership' do
      user.should have(1).memberships
    end
    
    it 'should create a position' do
      user.memberships.first.should have(1).positions
    end
  end
  
  describe 'listing' do
    let!(:membership) { create(:membership) }
    
    context 'as admin' do
      before do
        login create(:admin_user)
        visit memberships_path
      end
      
      it 'should show membership' do
        page.should have_css("#membership-#{membership.id}")
      end
    end
    
    context 'as user' do
      before do
        login membership.user
        visit memberships_path
      end
      
      it 'should show membership' do
        page.should have_css("#membership-#{membership.id}")
      end
    end
    
    context 'as non authorized user' do
      before do
        visit memberships_path
      end
      
      it 'should show login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'showing' do
    let!(:membership) { create(:membership) }
    
    context 'as admin' do
      before do
        login create(:admin_user)
        visit membership_path(membership)
      end
      
      it 'should show membership' do
        page.should have_css("#membership-#{membership.id}-detail")
      end
    end
    
    context 'as user' do
      before do
        login membership.user
        visit membership_path(membership)
      end
      
      it 'should show membership' do
        page.should have_css("#membership-#{membership.id}-detail")
      end
    end
    
    context 'as non authorized user' do
      before do
        visit membership_path(membership)
      end
      
      it 'should show login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'closing' do
    let!(:membership) { create(:membership) }
    
    context 'as admin' do
      before do
        login create(:admin_user)
        visit membership_path(membership)
        click_link 'close'
        confirm_dialog
      end
      
      it 'should close membership' do
        membership.reload.should be_closed
      end
    end
    
    context 'as user' do
      before do
        login membership.user
        visit membership_path(membership)
        click_link 'close'
        confirm_dialog
      end
      
      it 'should close membership' do
        membership.reload.should be_closed
      end
    end
  end
end
