require 'spec_helper'

describe 'Root management' do
  context 'as non authorized user' do
    before { visit root_path }
    
    it 'should redirect to sign in page' do
      current_path.should == new_session_path
    end
  end
  
  context 'as authorized user' do
    it 'should redirect to dashboard page' do
      pending "current_user doesn't be implemented jet"
      current_path.should == dashboard_page
    end
  end
end
