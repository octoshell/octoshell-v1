require 'spec_helper'

describe ClusterProject do
  let(:cluster_project) { create(:cluster_project) }
  subject { cluster_project }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:cluster) }
  
  describe '#activate' do
    context 'closed' do
      before do
        cluster_project.activate
      end
      
      it { should be_activing }
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
  end
  
  describe '#close' do
    before do
      cluster_project.activate
      cluster_project.complete_activation
      cluster_project.cluster_users.each &:complete_activation
      cluster_project.close
    end
    
    it { should be_closing }
  end
end
