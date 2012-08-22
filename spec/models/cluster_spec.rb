require 'spec_helper'

describe Cluster do
  let(:cluster) { create(:cluster) }
  subject { cluster }
  
  it 'should have a factory' do
    should be
  end
  
  it { should have_many(:requests) }
  it { should have_many(:cluster_users) }
  it { should have_many(:tickets) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:host) }
  it { should validate_presence_of(:add_user) }
  it { should validate_presence_of(:del_user) }
  it { should validate_presence_of(:add_openkey) }
  it { should validate_presence_of(:del_openkey) }
  it { should validate_presence_of(:block_user) }
  it { should validate_presence_of(:unblock_user) }
  it { should validate_presence_of(:get_statistic) }
  
  # it { should allow_mass_assignment_of(:name) }
  # it { should allow_mass_assignment_of(:host) }
  # it { should allow_mass_assignment_of(:description) }
  # it { should allow_mass_assignment_of(:add_user) }
  # it { should allow_mass_assignment_of(:del_user) }
  # it { should allow_mass_assignment_of(:add_openkey) }
  # it { should allow_mass_assignment_of(:del_openkey) }
  # it { should allow_mass_assignment_of(:block_user) }
  # it { should allow_mass_assignment_of(:unblock_user) }
  
  describe '#close' do
    let!(:request) { create(:active_request, cluster: cluster) }
    
    before { cluster.close }
    
    subject { request.reload }
    
    it { cluster.should be_closed }
    its(:comment) { should == I18n.t('requests.cluster_closed') }
    it { should be_closed }
  end
  
  describe 'updating cluster statistics' do
    let(:task) { cluster.tasks.setup(:get_statistic) }
    
    before do
      task.stdout = "boo"
      task.perform_callbacks!
      cluster.reload
    end
    
    it { cluster.statistic_updated_at.to_s.should == task.updated_at.to_s }
    its(:statistic) { should == "boo" }
  end
end
