require 'spec_helper'

describe 'Authentication' do
  before { visit new_session_path }
  
  context 'as non authotized user' do
    context 'with correctly filled form' do
      it 'should authenticate user'
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
