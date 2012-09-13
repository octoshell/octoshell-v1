require 'spec_helper'

describe 'Dashboard', js: true do
  context 'authorized user' do
    let!(:user) { create(:user) }
    let!(:ticket) { create(:ticket, user: user) }
    let!(:request) { create(:request, user: user) }
    
    before do
      login user
    end
    
    it 'should show tickets' do
      page.should have_css("#ticket-#{ticket.id}")
    end
    
    it 'should show requests' do
      page.should have_css("#request-#{request.id}")
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
