require 'spec_helper'

describe Surety do
  let(:surety) { create(:surety) }
  subject { surety }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it 'should create surety only for non closed organization' do
    organization = build(:surety, organization: create(:closed_organization))
    organization.should have(1).errors_on(:organization_state_name)
  end
  
  describe '#activate' do
    it 'should revalidate user' do
      surety.user.should_receive(:revalidate!).once
      surety.activate
    end
  end
  
  describe '#close' do
    it do
      surety.close
      should be_closed
    end
    
    it 'should revalidate user' do
      surety.user.should_receive(:revalidate!).once
      surety.close
    end
  end
end
