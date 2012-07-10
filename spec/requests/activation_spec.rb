require 'spec_helper'

describe 'Activation' do
  context 'with right token' do
    let(:user) { create(:inactive_user) }
    before do
      user.send :send_activation_needed_email!
      visit activate_user_path(token: user.activation_token)
    end
    
    it 'should activate user' do
      current_user.should be_active
    end
    
    it 'should authorize user' do
      current_user.should == user
    end
    
    it 'should redirect to after login page' do
      current_path.should == dashboard_path
    end
  end
  
  context 'with wrong token' do
    before { visit activate_user_path(token: 'nope') }
    
    it 'should redirect to new session page' do
      current_path.should == new_session_path
    end
  end
end
