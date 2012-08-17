require 'spec_helper'

describe Account do
  let(:account) { create(:account) }
  subject { account }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_uniqueness_of(:project_id).scoped_to(:user_id) }
  
  it { should allow_mass_assignment_of(:project_id) }
  it { should allow_mass_assignment_of(:raw_emails) }
  
  it 'should create account only for sured users' do
    account = build(:account, user: create(:closed_user))
    account.activate
    account.errors[:user_state_name].should be
  end
  
  it 'should create account only for active projects' do
    account = build(:account, project: create(:closed_project))
    account.should have(1).errors_on(:project_state_name)
  end
  
  describe '#accesses' do
    let!(:user)         { create(:sured_user) }
    let!(:project)      { create(:project) }
    let!(:account)      { create(:active_account, project: project, user: user) }
    let!(:credential)   { create(:credential, user: user) }
    let!(:cluster_user) { create(:cluster_user, project: project) }
    let!(:access)       { create(:access, credential: credential, cluster_user: cluster_user) }
    
    subject { account.accesses }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [access] }
  end
  
  describe '#close' do
    let!(:user)         { create(:sured_user) }
    let!(:project)      { create(:project) }
    let!(:account)      { create(:active_account, project: project, user: user) }
    let!(:credential)   { create(:credential, user: user) }
    let!(:cluster_user) { create(:cluster_user, project: project) }
    let!(:access)       { create(:active_access, credential: credential, cluster_user: cluster_user) }
    
    before { account.close }
    
    it { should be_closed }
    
    it 'should close all active accesses' do
      account.accesses.each do |access|
        access.should be_closing
      end
    end
  end
  
  describe '#activate' do
    context 'possible user' do
      let!(:user)         { create(:sured_user) }
      let!(:project)      { create(:project) }
      let!(:account)      { create(:account, project: project, user: user) }
      let!(:request)      { create(:active_request, project: project, user: project.user) }
      let!(:credential)   { create(:credential, user: user) }
      
      before { account.activate }

      subject { account }
      
      it { should be_active }
      it { account.should have(1).accesses }
      it { account.accesses.all?(&:activing?).should be_true }
    end
    
    context 'imposible user' do
      let!(:user) { create(:user) }
      let!(:project) { create(:project) }
      let!(:account) { create(:account, project: project, user: user) }
      
      before { account.activate }
      
      it { should be_pending }
    end
  end
end
