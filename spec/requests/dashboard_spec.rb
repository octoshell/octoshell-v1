require 'spec_helper'

describe 'Dashboard' do
  let!(:user) { create(:user) }
  
  describe 'Requests' do
    let!(:project) { create(:project) }
    let!(:account) { create(:account, user: user, project: project) }
    let!(:requests) { 10.times.map { create(:request, project: project) } }
    
    before do
      login user
      visit dashboard_path
    end
    
    it 'should show 5 last requests' do
      requests.last(5).each do |request|
        within('#requests') do
          page.should have_content(request.id)
          page.should have_link(request.cluster.name)
          page.should have_content(request.created_at.to_formatted_s(:short))
        end
      end
    end
    
    it 'should have a link to all requests' do
      within('#requests') do
        page.should have_link(I18n.t 'pages.dashboard.all_requests')
      end
    end
  end
end
