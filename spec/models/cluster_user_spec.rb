require 'spec_helper'

describe ClusterUser do
  let(:cluster_user) { create(:pending_cluster_user) }
  subject { cluster_user }
  
  it { should belong_to(:project) }
  it { should belong_to(:cluster) }
  it { should have_many(:tasks) }
  it { should have_many(:accesses) }
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:cluster) }
  
  it { should be_pending }
  
  describe '.activate_for' do
    let!(:project) { create(:project) }
    let!(:cluster) { create(:cluster) }
    
    context 'if non closed cluster user exists' do
      let!(:cluster_user) do
        create(:active_cluster_user, project: project, cluster: cluster)
      end
      
      it 'should create new cluster user' do
        ClusterUser.activate_for(project.id, cluster.id)
        conditions = { project_id: project.id, cluster_id: cluster.id }
        ClusterUser.where(conditions).count.should == 1
      end
    end
    
    context 'if cluster user not exists' do
      it 'should create new cluster user' do
        ClusterUser.activate_for(project.id, cluster.id)
        conditions = { project_id: project.id, cluster_id: cluster.id }
        ClusterUser.where(conditions).count.should == 1
      end
    end
  end
  
  describe '.close_for' do
    let!(:cluster_user) { create(:cluster_user) }
    
    before do
      ClusterUser.close_for(cluster_user.project_id, cluster_user.cluster_id)
    end
    
    it 'should close all cluster users' do
      cluster_user.reload.should be_closing
    end
  end
  
  describe '.pause_for' do
    let!(:cluster_user) { create(:active_cluster_user) }
    
    before do
      ClusterUser.pause_for(cluster_user.project_id, cluster_user.cluster_id)
    end
    
    it 'should close all cluster users' do
      cluster_user.reload.should be_pausing
    end
  end
  
  describe '#users' do
    let!(:owner) { cluster_user.project.user }
    let!(:invited) { create(:active_account, project: cluster_user.project).user }
    
    subject { cluster_user.users }
    
    it { should include(owner) }
    it { should include(invited) }
  end
  
  describe '#processing?' do
    %w(activing pausing resuming closing).each do |state|
      it "#{state} should be processing" do
        state = create("#{state}_cluster_user")
        state.should be_processing
      end
    end
  end
  
  describe '#activate' do
    context 'pending' do
      let(:cluster_user) { create(:pending_cluster_user) }
      
      before { cluster_user.activate }
      
      it { should be_activing }
      it { cluster_user.tasks.add_user.pending.count.should == 1 }
    end
    
    context 'paused' do
      let(:cluster_user) { create(:paused_cluster_user) }
      
      before { cluster_user.activate }
      
      it { should be_resuming }
      it { cluster_user.tasks.unblock_user.pending.count.should == 1 }
    end
    
    context 'processing state' do
      let(:cluster_user) { create(:resuming_cluster_user) }
      
      it do
        cluster_user.activate.should be_false
        cluster_user.errors.any?.should be_true
      end
      
      it do
        expect { cluster_user.activate! }.to raise_error
      end
    end
  end
  
  describe '#complete_activation' do
    let!(:project) { create(:project) }
    let!(:account) { create(:active_account, project: project, user: project.user) }
    let!(:credential) { create(:credential, user: project.user) }
    let(:cluster_user) { create(:activing_cluster_user, project: project) }
    
    before { cluster_user.complete_activation }
    
    it { should be_active }
    
    it 'should create accesses for active project accounts' do
      should have(1).accesses
    end
  end
  
  describe '#pause' do
    let(:cluster_user) { create(:active_cluster_user) }
    
    before { cluster_user.pause }
    
    it { should be_pausing }
    it { cluster_user.tasks.block_user.pending.count.should == 1 }
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
    it { cluster_user.tasks.unblock_user.pending.count.should == 1 }
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
      it { cluster_user.tasks.del_user.pending.count.should == 1 }
    end
  end
  
  describe '#complete_closure' do
    let(:cluster_user) { create(:closing_cluster_user) }
    
    before { cluster_user.complete_closure }
    
    it { should be_closed }
  end
  
  describe '#force_close' do
    before { cluster_user.force_close }
    
    it { should be_closed }
  end
end
