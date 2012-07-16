require 'spec_helper'

describe Cluster do
  let(:cluster) { create(:cluster) }
  subject { cluster }
  
  it 'should have a factory' do
    should be
  end
  
  it { should have_many(:requests) }
  
  it { should validate_presence_of(:name) }
  
  it { should allow_mass_assignment_of(:name) }
  
  describe 'destroying' do
    let!(:request) { create(:request, cluster: cluster) }
    
    before { cluster.destroy }
    
    subject { request.reload }
    
    its(:comment) { should == I18n.t('requests.cluster_destroyed') }
    
    context 'pending' do
      it { should be_declined }
    end
    
    context 'active' do
      let!(:request) { create(:active_request, cluster: cluster) }
      
      it { should be_finished }
    end
  end
end
