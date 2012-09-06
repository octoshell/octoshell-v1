require 'spec_helper'

describe 'Accesses', js: true do
  let!(:access) { a = Fixture.active_access }
  
  context 'listing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit accesses_path
      end

      it 'should show access' do
        page.should have_css("#access-#{access.id}")
      end
    end

    context 'as user' do
      before do
        login
        visit accesses_path
      end

      it 'should redirect to dashboard path' do
        current_path.should == dashboard_path
      end
    end

    context 'as non authorized user' do
      before do
        visit accesses_path
      end

      it 'should redirect to login path' do
        current_path.should == new_session_path
      end
    end
  end
  
  context 'showing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit access_path(access)
      end

      it 'should show access' do
        page.should have_css("#access-#{access.id}-detail")
      end
    end

    context 'as user' do
      before do
        login
        visit access_path(access)
      end

      it 'should redirect to dashboard path' do
        current_path.should == dashboard_path
      end
    end

    context 'as non authorized user' do
      before do
        visit access_path(access)
      end

      it 'should redirect to login path' do
        current_path.should == new_session_path
      end
    end
  end
end
