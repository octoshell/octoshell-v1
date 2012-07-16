# coding: utf-8
require 'spec_helper'

describe 'Clusters' do
  describe 'listing' do
    let!(:cluster) { create(:cluster) }
    
    before do
      login create(:admin_user)
      visit admin_clusters_path
    end
    
    it 'should show cluster' do
      page.should have_content(cluster.name)
    end
  end
  
  describe 'showing' do
    let!(:cluster) { create(:cluster) }
    
    before do
      login create(:admin_user)
      visit admin_cluster_path(cluster)
    end
    
    it 'should show cluster' do
      page.should have_content(cluster.name)
    end
  end
  
  describe 'creating' do
    let!(:cluster) { build(:cluster) }
    
    before do
      login create(:admin_user)
      visit new_admin_cluster_path
      fill_in 'cluster_name', with: cluster.name
      fill_in 'cluster_host', with: cluster.host
      fill_in 'cluster_description', with: cluster.description
      click_button 'Создать'
    end
    
    it 'should create new cluster' do
      Cluster.find_by_name(cluster.name).should be
    end
  end
  
  describe 'updating' do
    let!(:cluster) { create(:cluster) }
    let(:new_name) { cluster.name + '1' }
    
    before do
      login create(:admin_user)
      visit edit_admin_cluster_path(cluster)
      fill_in 'cluster_name', with: new_name
      click_button 'Сохранить'
    end
    
    it 'should update cluster' do
      cluster.reload.name.should == new_name
    end
  end
  
  describe 'destroying' do
    let!(:cluster) { create(:cluster) }
    
    before do
      login create(:admin_user)
      visit admin_cluster_path(cluster)
      click_link 'Удалить'
    end
    
    it 'should destroy cluster' do
      Cluster.find_by_id(cluster.id).should_not be
    end
  end
end
