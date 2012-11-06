require 'spec_helper'

describe Surety do
  let(:surety) { create(:surety) }
  subject { surety }
  
  it 'should have a factory', factory: true do
    should be
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
