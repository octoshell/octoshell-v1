require 'spec_helper'

describe SuretyMember do
  let(:surety_member) { create(:surety_member) }
  subject { surety_member }
  
  it 'should create account code on create' do
    ac = build(:surety_member, account_code: nil)
    ac.save
    ac.account_code.should be
  end
end
