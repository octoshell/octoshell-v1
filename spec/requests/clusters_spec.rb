require 'spec_helper'

describe 'Clusters', js: true do
  let!(:cluster) { create(:cluster) }
  
  describe 'listing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit clusters_path
      end
      
      it 'should show cluster' do
        page.should have_css("#cluster-#{cluster.id}")
      end
    end
    
    context 'as user' do
      before do
        login
        visit clusters_path
      end
      
      it 'should show cluster' do
        page.should have_css("#cluster-#{cluster.id}")
      end
    end
    
    context 'as non authorized user' do
      before do
        visit clusters_path
      end
      
      it 'should show login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'updating' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit edit_cluster_path(cluster)
        fill_in 'Name', with: "Boo"
        click_button 'Update Cluster'
      end
      
      it 'should update cluster' do
        cluster.reload.name.should == "Boo"
      end
    end
    
    context 'as user' do
      before do
        login
        visit edit_cluster_path(cluster)
      end
      
      it 'should show dashboard page' do
        current_path.should == dashboard_path
      end
    end
    
    context 'as non authorized user' do
      before do
        visit edit_cluster_path(cluster)
      end
      
      it 'should show login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'showing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit cluster_path(cluster)
      end
      
      it 'should show cluster' do
        page.should have_css("#cluster-#{cluster.id}-detail")
      end
      
      it 'should show cluster statistics' do
        page.should have_css("#cluster-#{cluster.id}-statistics")
      end
    end
    
    context 'as user' do
      before do
        login
        visit cluster_path(cluster)
      end
      
      it 'should show cluster' do
        page.should have_css("#cluster-#{cluster.id}-detail")
      end
    end
    
    context 'as non authorized user' do
      before do
        visit cluster_path(cluster)
      end
      
      it 'should show login page' do
        current_path.should == new_session_path
      end
    end
  end
  
  describe 'closing' do
    context 'as admin' do
      before do
        login create(:admin_user)
        visit cluster_path(cluster)
        click_link 'close'
        confirm_dialog
      end
      
      it 'should close cluster' do
        cluster.reload.should be_closed
      end
    end
  end
end
