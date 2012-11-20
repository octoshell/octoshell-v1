require 'spec_helper'

describe SuretyMember do
  let(:surety_member) { create(:surety_member) }
  subject { surety_member }
  
  it 'should assign user on create' do
    sm = build(:surety_member)
    sm.save
    sm.user.should == User.find_by_email(sm.email)
  end
  
  context 'creating with member of project' do
    pending
    it 'should create account code on create' do
      ac = build(:surety_member, account_code: nil)
      ac.save
      ac.account_code.should be
    end
  end
  
  context 'creating with project owner' do
    it 'should create account code on create' do
      ac = build(:surety_member, account_code: nil)
      ac.user = ac.surety.project.user
      ac.save
      conditions = { user_id: ac.user_id, project_id: ac.surety.project_id }
      Account.where(conditions).first.should be
    end
  end
end
