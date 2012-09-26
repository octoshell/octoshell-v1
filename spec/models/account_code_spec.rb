require 'spec_helper'

describe AccountCode do
  let(:user) { create(:sured_user) }
  let(:account_code) { create(:account_code) }
  subject { account_code }
  
  it { should be_valid }
  
  describe '#use' do
    def account
      Account.where(project_id: account_code.project_id, user_id: user.id).first
    end
    
    before { account_code.use(user) }
    
    it { should be_used }
    
    it 'should assign user' do
      account_code.user.should == user
    end
    
    it 'should create account' do
      account.should be
    end
    
    it 'should activate account' do
      account.should be_active
    end
  end
end
