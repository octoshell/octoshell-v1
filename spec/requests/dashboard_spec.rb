require 'spec_helper'

describe 'Dashboard', js: true do
  context 'authorized user' do
    before do
      login
    end
    
    it 'should show page' do
      page.should be
    end
  end
  
  context 'admin' do
    before do
      login create(:admin_user)
      visit dashboard_path
    end
    
    it { current_path.should == admin_path }
  end
  
  context 'non authorized user' do
    before { visit dashboard_path }
    
    it_behaves_like 'non authorized user'
  end
end
