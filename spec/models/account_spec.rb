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
  
  describe '#cancel', focus: true do
    let!(:cluster) { create(:cluster) }
    let(:account) { create(:active_account) }
    
    before { account.cancel! }
    
    it { should be_closed }
    it { account.accesses.all(&:closing?).should be_true }
  end
  
  describe '#activate', focus: true do
    before do
      create(:cluster)
      account.activate!
    end
    
    it { should be_active }
    it { account.accesses.all?(&:activing?).should be_true }
  end
end
