require 'spec_helper'

describe 'Authentication', js: true do
  describe 'login' do
    
    context 'as non authotized user' do
      context 'with correctly filled form' do
        let!(:user) { create(:user) }

        before do
          visit new_session_path
          fill_in 'user_email', with: user.email
          fill_in 'user_password', with: '123456'
          click_on I18n.t('pages.shared.login')
        end

        it 'should authenticate user' do
          current_user.should be
        end
      end

      context 'with non correctly filled form' do
        before do
          visit new_session_path
          click_on I18n.t('pages.shared.login')
        end

        it 'should return user to form' do
          page.should have_css('#new_user')
        end
      end
    end
    
    context 'as authotized user' do
      before do
        login
        visit new_session_path
      end
      
      it 'should be authorized' do
        current_user.should be
      end
      
      it 'should redirect to dashboard path' do
        pending "it works but capybara doesn't catch it"
        current_path.should == dashboard_path
      end
    end
  end
  
  describe 'logout' do
    context 'as authorized user' do
      before do
        login
        visit dashboard_path
        click_link I18n.t('pages.shared.logout')
      end
      
      it 'should deauthorize user' do
        current_user.should_not be
      end
    end
  end
end
