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
  
  describe '#accesses' do
    let!(:user)       { create(:sured_user) }
    let!(:project)    { create(:project) }
    let!(:account)    { create(:active_account, project: project, user: user) }
    let!(:credential) { create(:credential, user: user) }
    let!(:access)     { create(:access, credential: credential, project: project) }
    
    subject { account.accesses }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [access] }
  end
  
  describe '#close' do
    let!(:user)       { create(:sured_user) }
    let!(:project)    { create(:project) }
    let!(:account)    { create(:active_account, project: project, user: user) }
    let!(:credential) { create(:credential, user: user) }
    let!(:access)     { create(:active_access, credential: credential, project: project) }
    
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
      let!(:user)       { create(:sured_user) }
      let!(:project)    { create(:project) }
      let!(:account)    { create(:account, project: project, user: user) }
      let!(:request)    { create(:active_request, project: project, user: project.user) }
      let!(:credential) { create(:credential, user: user) }
      
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
