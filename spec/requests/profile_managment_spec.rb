require 'spec_helper'

describe 'Profile Managment' do
  context 'as authorized user' do
    before(:all) do
      login
      visit profile_path
    end
    
    it 'should have a link to edit' do
      page.should have_link(I18n.t('pages.profile.edit'))
    end
  end
  
  context 'as non authorized user' do
    before(:all) { visit profile_path }
    
    it { current_path.should == new_session_path }
  end
end
