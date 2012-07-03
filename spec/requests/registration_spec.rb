require 'spec_helper'

describe 'Registration' do
  before { visit new_user_path }
  
  context 'as non authotized user' do
    
  end
  
  context 'as authotized user' do
    let(:user) { create(:user) }
    before { login(user) }
    
    it 'should logout' do
      current_user.should be_nil
    end
    
    it 'should not change path' do
      current_path.should == new_user_path
    end
  end
end
