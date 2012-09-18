require 'spec_helper'

describe 'Importer' do
  let!(:cluster) { create(:cluster) }
  let!(:organization_kind) { create(:organization_kind) }
  let!(:file) do
    %(Mr. White;mrwhite@example.com;Ubmrella;Art;art_group;art_user;#{cluster.id};["public_key1", "public_key2"])
  end
  
  before { Importer.import(file) }
  
  def created_user
    User.find_by_first_name("Mr.")
  end
  
  def created_organization
    Organization.find_by_name("Ubmrella")
  end
  
  def created_project
    Project.find_by_name("Art")
  end
  
  def created_account
    Account.where(
      user_id: created_user.id,
      project_id: created_project.id
    ).first
  end
  
  def created_cluster_project
    ClusterProject.where(
      project_id: created_project.id,
      cluster_id: cluster.id
    ).first
  end
  
  def created_cluster_user
    ClusterUser.where(
      cluster_project_id: created_cluster_project.id,
      account_id: created_account.id
    ).first
  end
  
  def created_credential
    Credential.where(public_key: "public_key1").first
  end
  
  def created_access
    Access.where(credential_id: created_credential.id).first
  end
  
  describe 'created user' do
    subject { created_user }
    
    it { should be_valid }
    it { should be_sured }
    its(:email) { should == "mrwhite@example.com" }
    its(:activation_state) { should == 'active' }
    its(:token) { should be }
  end
  
  describe 'Organization' do
    subject { created_organization }
    
    it { should be_valid }
    it { should be_active }
  end
  
  describe 'Project' do
    subject { created_project }
    
    it { should be_valid }
    it { should be_active }
    its(:username) { should == 'art_group' }
  end
  
  describe 'Membership' do
    subject do
      Membership.where(
        user_id: created_user.id,
        organization_id: created_organization.id
      ).first
    end
    
    it { should be_valid }
    it { should be_active }
  end
  
  describe 'Surety' do
    subject { Surety.where(user_id: created_user.id).first }
    
    it { should be_valid }
    it { should be_active }
  end
  
  describe 'Account' do
    subject { created_account }
    
    it { should be_valid }
    it { should be_active }
  end
  
  describe 'Cluster Project' do
    subject { created_cluster_project }
    
    it { should be_valid }
    it { should be_active }
    its(:username) { should == 'art_group' }
    it { should have(0).tasks }
  end
  
  describe 'Cluster User' do
    subject { created_cluster_user }
    
    it { should be_valid }
    it { should be_active }
    its(:username) { should == 'art_user' }
    it { should have(0).tasks }
  end
  
  describe 'Access' do
    subject { created_access }
    
    it { should be_valid }
    it { should be_active }
    it { should have(0).tasks }
  end
end
