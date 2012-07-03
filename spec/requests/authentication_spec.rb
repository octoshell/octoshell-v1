require 'spec_helper'

describe 'Authentication' do
  before { visit new_session_path }
  
  context 'as non authotized user' do
    context 'with correctly filled form' do
      let!(:user) { create(:user) }
      
      before do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: '123456'
        click_on 'session_submit'
      end
      
      it 'should authenticate user' do
        current_user.should be
      end
    end
    
    context 'with non correctly filled form' do
      it 'should return user to form'
      
      it 'should show authentication errors'
    end
  end
  
  context 'as authotized user' do
    it 'should be authorized'
  end
end
