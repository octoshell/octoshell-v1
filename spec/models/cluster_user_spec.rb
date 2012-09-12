require 'spec_helper'

describe ClusterUser do
  let(:cluster_user) { create(:cluster_user) }
  subject { cluster_user }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should belong_to(:account) }
  it { should belong_to(:cluster_project) }
  it { should have_many(:tasks) }
  it { should have_many(:accesses) }
  
  it { should validate_presence_of(:account) }
  it { should validate_presence_of(:cluster_project) }
  
  it { should be_closed }
  its(:username) { should be }
  
  describe '#activate', focus: true do
    before do
      cluster_user.account.activate!
      cluster_user.cluster_project.activate!
      cluster_user.cluster_project.complete_activation!
    end
    
    it { cluster_user.reload.should be_activing }
  end
  
  describe '#close', focus: true do
    let(:cluster_user) { create(:active_cluster_user) }
    
    before { cluster_user.close }
    
    it { should be_closing }
  end
  
  describe '#complete_closure' do
    let(:cluster_user) { create(:closing_cluster_user) }
    
    before do
      cluster_user.complete_closure
    end
    
    it { should be_closed }
    it { cluster_user.accesses.reload.all?(&:closed?).should be_true }
  end
end
