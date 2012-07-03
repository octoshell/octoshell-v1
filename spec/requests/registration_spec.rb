require 'spec_helper'

describe 'Registration' do
  context 'as non authotized user' do
    let(:user) { build(:user) }
    before do
      visit new_user_path
      fill_in 'user_email',                 with: user.email
      fill_in 'user_password',              with: user.password
      fill_in 'user_password_confirmation', with: user.password
      fill_in 'user_first_name',            with: user.first_name
      fill_in 'user_last_name',             with: user.last_name
      click_button 'user_submit'
    end
    
    it 'should create new user' do
      User.find_by_email(user.email).should be
    end
  end
  
  context 'as authotized user' do
    let(:user) { create(:user) }
    before do
      login(user)
      visit new_user_path
    end
    
    it 'should logout' do
      current_user.should be_nil
    end
    
    it 'should not change path' do
      current_path.should == new_user_path
    end
  end
end
