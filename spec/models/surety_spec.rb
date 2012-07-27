require 'spec_helper'

describe Surety do
  let(:surety) { create(:surety) }
  subject { surety }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:organization) }
  
  it { should allow_mass_assignment_of(:organization_id) }
  
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
