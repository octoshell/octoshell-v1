require 'spec_helper'

describe ClusterProject do
  let(:cluster_project) { Fixture.cluster_project }
  subject { cluster_project }
  
  it { should be }
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:cluster) }
  
  describe '#activate' do
    context 'initialized' do
      before do
        cluster_project.activate
      end
      
      it { should be_activing }
      it { cluster_project.tasks.first.should be_add_project }
    end
    
    context 'paused' do
      before do
        cluster_project.activate
        cluster_project.complete_activation
        cluster_project.cluster_users.each &:complete_activation
        cluster_project.pause
        cluster_project.complete_pausing
        cluster_project.activate
      end
      
      it { should be_activing }
      it { cluster_project.tasks.first.should be_unblock_project }
    end
  end
  
  describe '#pause' do
    before do
      cluster_project.activate
      cluster_project.complete_activation
      cluster_project.cluster_users.each &:complete_activation
      cluster_project.pause
    end
    
    it { should be_pausing }
    it { cluster_project.tasks.first.should be_block_project }
  end
  
  describe '#close' do
    before do
      cluster_project.activate
      cluster_project.complete_activation
      cluster_project.cluster_users.each &:complete_activation
    end
    
    it { should be_closing }
    it { cluster_project.tasks.first.should be_del_project }
  end
end
