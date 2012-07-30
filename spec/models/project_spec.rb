require 'spec_helper'

describe Project do
  let(:project) { create(:project) }
  subject { project }
  
  it 'should have a factory' do
    should be
  end
  
  it { should have_many(:requests) }
  it { should have_many(:accounts) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user) }
  it { should validate_uniqueness_of(:name) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:requests_attributes) }
  
  describe '#clusters' do
    let!(:available_cluster) { create(:cluster) }
    let!(:not_available_cluster) { create(:cluster) }
    before do
      create(:active_request, cluster: available_cluster, project: project, user: project.user)
      create(:closed_request, cluster: not_available_cluster, project: project, user: project.user)
    end
    
    subject { project.clusters }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [available_cluster] }
  end
  
  describe '#close' do
    let!(:request) { create(:request, project: project, user: project.user) }
    let!(:account) { create(:account, project: project) }
    
    before { project.close }
    
    it 'should close project' do
      project.should be_closed
    end
    
    it 'should close accounts' do
      project.accounts.all?(&:closed?).should be_true
    end
    
    it 'should cancel all requests' do
      project.requests.each do |request|
        (request.closed? || request.closing?).should be_true
      end
    end
  end
end
