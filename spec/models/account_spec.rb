require 'spec_helper'

describe Account do
  let(:account) { create(:account) }
  subject { account }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  
  it { should allow_mass_assignment_of(:project_id) }
  
  it 'should create account only for sured users' do
    account = build(:account, user: create(:closed_user))
    account.activate
    account.errors[:user_state_name].should be
  end
  
  describe '#activate' do
    let!(:cluster) { create(:cluster) }
    let!(:project) { create(:project) }
    let!(:account) { create(:account, project_id: project.id) }
    let!(:request) { create(:request, project_id: project.id, cluster_id: cluster.id) }
    
    before { request.activate! }
    
    it 'should activate account' do
      account.activate!
      account.should be_active
    end
    
    context 'with possible to activate cluster user' do
      before do
        cp = request.cluster_project
        cp.complete_activation!
        account.activate!
      end
      
      it 'should activate cluster users' do
        account.cluster_users(true).all?(&:activing?).should be_true
      end
    end
    
    context 'with not possible to activate cluster user' do
      before { account.activate! }
      
      it 'should not activate cluster users' do
        account.cluster_users.all?(&:closed?).should be_true
      end
    end
  end
  
  describe '#cancel', focus: true do
    let!(:cluster) { create(:cluster) }
    let!(:project) { create(:project) }
    let!(:account) { create(:account, project_id: project.id) }
    let!(:request) { create(:request, project_id: project.id, cluster_id: cluster.id) }
    
    before do
      account.activate!
      request.activate!
      cp = request.cluster_project
      cp.complete_activation!
      cu = cp.cluster_users.where(account_id: account.id).first!
      cu.complete_activation!
      account.cancel!
    end
    
    it { should be_closed }
    it 'should close cluster users' do
      account.should have(1).cluster_users(true)
      account.cluster_users(true).all?(&:closing?).should be_true
    end
  end
end
