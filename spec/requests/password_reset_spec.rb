require 'spec_helper'

describe 'Password Reset' do
  context 'as authotized user' do
    before do
      login
      visit new_password_path
    end
    
    it 'should redirect to user edit profile page' do
      current_path.should == edit_profile_path
    end
  end
  
  describe 'sending instructions' do
    context 'with right email' do
      let(:user) { create(:user) }
      before do
        visit new_password_path
        fill_in 'user_email', with: user.email
        User.stub(:find_by_email) do |email|
          email == user.email ? user : nil
        end
      end
    
      it 'should send instructions' do
        user.should_receive(:deliver_reset_password_instructions!).once
        click_button 'reset_password'
      end
    
      it 'should redirect to confirmation password page' do
        click_button 'reset_password'
        current_path.should == confirmation_password_path
      end
    end
  
    context 'with wrong email' do
      before do
        visit new_password_path
        fill_in 'user_email', with: 'tratata'
        click_button 'reset_password'
      end
    
      it 'should redirect to new password page' do
        current_path.should == new_password_path
      end
    end
  end
  
  describe 'changing password' do
    context 'with right token' do
      let(:user) { create(:user) }
      before do
        user.deliver_reset_password_instructions!
        visit change_password_path(token: user.reset_password_token)
      end
      
      it 'should authorize user' do
        current_user.should == user
      end
      
      it 'should redirect to edit profile page' do
        current_path.should == edit_profile_path
      end
    end
    
    context 'with wrong token' do
      before { visit change_password_path(token: 'nope') }
      
      it 'should redirect to new session page' do
        current_path.should == new_session_path
      end
    end
  end
end
