require 'spec_helper'

describe 'Cluster Users', js: true do
  let!(:cluster_user) { create(:active_cluster_user) }
  
  context 'listing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit cluster_users_path
      end
      
      it 'should show cluster user' do
        page.should have_css("#cluster-user-#{cluster_user.id}")
      end
    end

    context 'as user' do
      before do
        login
        visit cluster_users_path
      end
      
      it 'should redirect to dashboard' do
        current_path.should == dashboard_path
      end
    end

    context 'as non authorized user' do
      before do
        visit cluster_users_path
      end
      
      it 'should redirect to login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  context 'showing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit cluster_user_path(cluster_user)
      end
      
      it 'should show cluster user' do
        page.should have_css("#cluster-user-#{cluster_user.id}-detail")
      end
    end
    
    context 'as other user' do
      before do
        login
        visit cluster_user_path(cluster_user)
      end
      
      it 'should show dashboard page' do
        current_path.should == dashboard_path
      end
    end

    context 'as non authorized user' do
      before do
        visit cluster_user_path(cluster_user)
      end
      
      it 'should show login page' do
        current_path.should == new_session_path
      end
    end
  end
end
