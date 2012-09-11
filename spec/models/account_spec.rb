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
  it { should allow_mass_assignment_of(:raw_emails) }
  
  it 'should create account only for sured users' do
    account = build(:account, user: create(:closed_user))
    account.activate
    account.errors[:user_state_name].should be
  end
  
  describe '#accesses' do
    let!(:fixture)      { Fixture.new }
    let!(:user)         { fixture.user }
    let!(:project)      { fixture.project }
    let!(:account)      { fixture.account }
    let!(:credential)   { fixture.credential }
    let!(:cluster_user) { fixture.cluster_user }
    let!(:access)       { fixture.access }
    
    subject { account.accesses }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [access] }
  end
  
  describe '#cancel' do
    let!(:fixture)      { Fixture.new }
    let!(:user)         { fixture.user }
    let!(:project)      { fixture.project }
    let!(:account)      { fixture.account }
    let!(:credential)   { fixture.credential }
    let!(:cluster_user) { fixture.cluster_user }
    let!(:access)       { fixture.access }
    
    before { account.cancel }
    
    it { should be_closed }
    it { account.accesses.all(&:closing?).should be_true }
  end
  
  describe '#activate!', focus: true do
    let!(:fixture)      { Fixture.new }
    let!(:user)         { fixture.user }
    let!(:project)      { fixture.project }
    let!(:account)      { fixture.account }
    let!(:credential)   { fixture.credential }
    
    before { account.activate! }

    subject { account }
    
    it { should be_active }
    it { account.accesses.all?(&:activing?).should be_true }
  end
end
