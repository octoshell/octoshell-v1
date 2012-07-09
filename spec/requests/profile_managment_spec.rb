require 'spec_helper'

describe 'Profile Managment' do
  context 'as authorized user' do
    let(:user) { create(:user) }
    
    describe 'Showing profile' do
      before do
        login user
        3.times { create(:credential, user: user) }
        visit profile_path
      end
    
      it 'should have a link to edit user' do
        page.should have_link(I18n.t('pages.profile.edit_user'))
      end
    
      it 'should have a link to new credential' do
        page.should have_link(I18n.t('pages.profile.new_credential'))
      end
    
      it 'should show credentials' do
        user.credentials.each do |credential|
          page.should have_content(credential.name)
          page.should have_content(credential.public_key)
          page.should have_link(I18n.t('pages.profile.destroy_credential'))
        end
      end
    end
    
    describe 'Editing profile' do
      before do
        login
        visit edit_profile_path
        fill_in 'user_first_name', with: 'Moe'
        click_on 'user_submit'
      end
      
      it 'should redirect to profile path' do
        current_path.should == profile_path
      end
      
      it 'should save record' do
        within('#profile') do
          page.should have_content('Moe')
        end
      end
    end
  end
  
  context 'as non authorized user' do
    before(:all) { visit profile_path }
    
    it { current_path.should == new_session_path }
  end
end
