require 'spec_helper'

describe 'Registration', js: true do
  context 'as non authotized user' do
    let(:user) { build(:user) }
    let!(:organization) { create(:organization) }
    
    before do
      visit new_user_path
      within('#new_user') do
        fill_in 'Email',                 with: user.email
        fill_in 'Password',              with: user.password
        fill_in 'Password confirmation', with: user.password
        fill_in 'First name',            with: user.first_name
        fill_in 'Last name',             with: user.last_name
        click_button 'Create User'
      end
    end
    
    it 'should create new user' do
      User.find_by_email(user.email).should be
    end
    
    it 'should show surety page' do
      current_path.should == confirmation_users_path
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
