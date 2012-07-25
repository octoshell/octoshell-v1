require 'spec_helper'

describe Cluster do
  let(:cluster) { create(:cluster) }
  subject { cluster }
  
  it 'should have a factory' do
    should be
  end
  
  it { should have_many(:requests) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:host) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:host) }
  it { should allow_mass_assignment_of(:description) }
  
  describe '#close' do
    let!(:request) { create(:active_request, cluster: cluster) }
    
    before { cluster.close }
    
    subject { request.reload }
    
    it { cluster.should be_closed }
    its(:comment) { should == I18n.t('requests.cluster_closed') }
    it { should be_closed }
  end
end
