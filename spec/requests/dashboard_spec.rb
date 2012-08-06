require 'spec_helper'

describe 'Dashboard', js: true do
  context 'authorized user' do
    let!(:user) { create(:sured_user) }
    let!(:credential) { create(:credential, user: user) }
    let!(:ticket) { create(:ticket, user: user) }
    let!(:project) { create(:project, user: user) }
    let!(:account) { create(:active_account, project: project, user: user) }
    let!(:request) { create(:active_request, project: project, user: user) }
    let!(:cluster_user) { request.cluster_users.first }
    let!(:access) { cluster_user.complete_activation!; cluster_user.accesses.first }
    
    before do
      login user
    end
    
    it 'should show tickets' do
      page.should have_css("#ticket-#{ticket.id}")
    end
    
    it 'should show requests' do
      page.should have_css("#request-#{request.id}")
    end
    
    it 'should show accesses' do
      page.should have_css("#access-#{access.id}")
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
