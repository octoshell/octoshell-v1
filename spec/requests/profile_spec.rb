require 'spec_helper'

describe 'Profile', js: true do
  context 'as authorized user' do
    let(:user) { create(:user) }
    
    describe 'Showing profile' do
      before do
        login user
        visit profile_path
      end
      
      it { current_path.should == profile_path }
    end
    
    describe 'Editing profile' do
      before do
        login
        visit edit_profile_path
        fill_in 'First name', with: 'Moe'
        click_on 'Update User'
      end
      
      it 'should redirect to profile path' do
        current_path.should == profile_path
      end
      
      it 'should save record' do
        current_user.first_name.should == 'Moe'
      end
    end
  end
  
  context 'as non authorized user' do
    before { visit profile_path }
    
    it { current_path.should == new_session_path }
  end
end
