require 'spec_helper'

describe 'Admin::Requests' do
  context 'show all requests' do
    before do
      login create(:admin_user)
      3.times { create(:request) }
      visit admin_requests_path
    end
    
    it 'should show all requests' do
      Request.all.each do |request|
        within('#requests') do
          page.should have_content(request.id)
        end
      end
    end
  end
  
  context 'show request' do
    before do
      login create(:admin_user)
      visit admin_request_path(request)
    end
  
    context 'pending request' do
      let(:request) { create(:request) }
    
      describe 'activate' do
        before do
          within('#request') do
            click_link I18n.t('pages.admin.request.activate')
            request.reload
          end
        end
      
        it 'should activate request' do
          request.should be_active
        end
      end
    
      describe 'decline' do
        before do
          within('#request') do
            click_link I18n.t('pages.admin.request.decline')
            request.reload
          end
        end
      
        it 'should decline request' do
          request.should be_declined
        end
      end
    end
  
    context 'active request' do
      let(:request) { create(:active_request) }
    
      describe 'finish' do
        before do
          within('#request') do
            click_link I18n.t('pages.admin.request.finish')
            request.reload
          end
        end
      
        it 'should finish request' do
          request.should be_finished
        end
      end
    end
  end
end