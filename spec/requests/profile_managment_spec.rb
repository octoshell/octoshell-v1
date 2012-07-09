require 'spec_helper'

describe 'Profile Managment' do
  context 'as authorized user' do
    
  end
  
  context 'as non authorized user' do
    before(:all) { visit profile_path }
    
    it { current_path.should == new_session_path }
  end
end
