# coding: utf-8
require 'spec_helper'

describe 'Clusters', js: true do
  let!(:cluster) { create(:cluster) }
  
  describe 'creating' do
    context 'as admin' do
      let!(:cluster) { build(:cluster) }
      
      before do
        login create(:admin_user)
        visit new_cluster_path
        fill_in 'Name', with: cluster.name
        fill_in 'Host', with: cluster.host
        click_button 'Create Cluster'
      end
      
      it 'should create cluster' do
        Cluster.find_by_name(cluster.name).should be
      end
    end
  end
  
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
      
      it_behaves_like 'user without access'
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
  
  describe 'creating additional field', focus: true do
    context 'as admin' do
      let!(:cluster) { create(:cluster) }
      
      before do
        login create(:admin_user)
        visit edit_cluster_path(cluster)
        fill_in 'cluster_field_name', with: 'New Field'
        click_button 'Создать'
      end
      
      it 'should create cluster field' do
        ClusterField.find_by_name('New Field').should be
      end
    end
  end
  
  describe 'destroying additional field', focus: true do
    context 'as admin' do
      let!(:cluster) { create(:cluster) }
      let!(:cluster_field) { create(:cluster_field, cluster: cluster) }
      
      before do
        login create(:admin_user)
        visit edit_cluster_path(cluster)
        within "#cluster-field-#{cluster_field.id}" do
          click_link 'Удалить'
        end
        confirm_dialog
      end
      
      it 'should destroy additional field' do
        ClusterField.find_by_id(cluster_field.id).should_not be
      end
    end
  end
end
