require 'spec_helper'

describe 'Root management' do
  context 'as non authorized user' do
    before { visit root_path }
    
    it 'should redirect to sign in page' do
      current_path.should == new_session_path
    end
  end
  
  context 'as authorized user' do
    before do
      login
      visit root_path
    end
    
    it 'should redirect to dashboard page' do
      current_path.should == dashboard_path
    end
  end
end
