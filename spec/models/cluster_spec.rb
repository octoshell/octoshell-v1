require 'spec_helper'

describe Cluster do
  let(:cluster) { create(:cluster) }
  subject { cluster }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  describe '#close' do
    let!(:cluster) { create(:cluster) }
    let!(:project) { create(:project) }
    
    before { cluster.close }
    
    it { cluster.should be_closed }
  end
end
