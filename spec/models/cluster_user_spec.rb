require 'spec_helper'

describe ClusterUser do
  let(:cluster_user) { create(:cluster_user) }
  subject { cluster_user }
  
  it { should belong_to(:project) }
  it { should belong_to(:cluster) }
  it { should have_many(:tasks) }
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:cluster) }
  
  it { should be_pending }
  
  describe '#activate' do
    before { cluster_user.activate }
    
    it { should be_activing }
    it { should have(1).tasks }
  end
  
  describe '#complete_activation' do
    let(:cluster_user) { create(:activing_cluster_user) }
    
    before { cluster_user.complete_activation }
    
    it { should be_active }
  end
  
  describe '#pause' do
    let(:cluster_user) { create(:active_cluster_user) }
    
    before { cluster_user.pause }
    
    it { should be_pausing }
    it { should have(1).tasks }
  end
  
  describe '#complete_pausing' do
    let(:cluster_user) { create(:pausing_cluster_user) }
    
    before { cluster_user.complete_pausing }
    
    it { should be_paused }
  end
  
  describe '#resume' do
    let(:cluster_user) { create(:paused_cluster_user) }
    
    before { cluster_user.resume }
    
    it { should be_resuming }
    it { should have(1).tasks }
  end
  
  describe '#complete_resuming' do
    let(:cluster_user) { create(:resuming_cluster_user) }
    
    before { cluster_user.complete_resuming }
    
    it { should be_active }
  end
  
  describe '#close' do
    before { cluster_user.close }
    
    context 'pending' do
      it { should be_closed }
    end
    
    context 'any other' do
      let(:cluster_user) { create(:active_cluster_user) }
      
      it { should be_closing }
      it { should have(1).tasks }
    end
  end
  
  describe '#complete_closure' do
    let(:cluster_user) { create(:closing_cluster_user) }
    
    before { cluster_user.complete_closure }
    
    it { should be_closed }
  end
  
  describe '#force_close' do
    before { cluster_user.force_close }
  end
end
