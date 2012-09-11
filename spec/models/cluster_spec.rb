require 'spec_helper'

describe Cluster do
  let(:cluster) { create(:cluster) }
  subject { cluster }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should have_many(:tickets) }
  it { should have_many(:cluster_fields) }
  it { should have_many(:cluster_projects) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:host) }
  
  describe '#close' do
    let!(:fixture) { Fixture.new }
    let!(:request) { fixture.request }
    let!(:cluster) { fixture.cluster }
    
    before { cluster.close }
    
    it { cluster.should be_closed }
    it { should be_closed }
  end
end
