require 'spec_helper'

describe ClusterUser do
  let(:cluster_user) { Fixture.cluster_user }
  subject { cluster_user }
  
  it { should belong_to(:account) }
  it { should belong_to(:cluster_project) }
  it { should have_many(:tasks) }
  it { should have_many(:accesses) }
  
  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:cluster_project) }
  
  it { should be_initialized }
  
  describe '#activate' do
    before { cluster_user.activate }
    
    it { should be_activing }
  end
  
  describe '#close' do
    before do
      cluster_user.activate
      cluster_user.complete_activation
      cluster_user.close
    end
    
    it { should be_closing }
  end
  
  describe '#complete_closure' do
    before do
      cluster_user.activate
      cluster_user.complete_activation
      cluster_user.close
      cluster_user.accesses.each &:complete_activation
      cluster_user.complete_closure
    end
    
    it { should be_initialized }
    it { cluster_user.accesses.reload.all?(&:initialized?).should be_true }
  end
end
