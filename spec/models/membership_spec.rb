require 'spec_helper'

describe Membership do
  let(:membership) { create(:membership) }
  subject { membership }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should have_many(:positions) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:organization) }
  
  describe '#build_default_positions' do
    let!(:position_names) { 3.times.map { create(:position_name) } }
    let!(:position) do
      create(:position, name: position_names.first.name, membership: membership)
    end
    
    before { subject.build_default_positions }
    
    it 'should build missing positions' do
      should have(3).positions
    end
    
    it 'should stay persisted pestisted records' do
      subject.positions.find_all { |p| p.persisted? }.size.should == 1
    end
  end
end
