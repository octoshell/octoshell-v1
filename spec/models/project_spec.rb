require 'spec_helper'

describe Project do
  let(:project) { create(:project) }
  subject { project }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should have_many(:accounts) }
  it { should have_many(:tickets) }
  it { should have_many(:cluster_projects) }
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:organization) }
  it { should validate_uniqueness_of(:name) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:organization_id) }
  
  describe 'organization validation' do
    let!(:user) { create(:sured_user) }
    let!(:project) { build(:project, user: user) }
    
    context 'with allowed organization' do
      let!(:organization) { create(:organization) }
      
      before do
        create(:membership, user: user, organization: organization)
        project.organization = organization
      end
      
      it { should have(:no).errors_on(:organization) }
    end
    
    context 'with not allowed organization' do
      let!(:organization) { create(:organization) }
      
      before do
        project.organization = organization
      end
      
      it { should have(1).errors_on(:organization) }
    end
  end
  
  describe '#close' do
    let!(:fixture)      { Fixture.new }
    let!(:project)      { fixture.project }
    let!(:account)      { fixture.account }
    let!(:cluster_user) { fixture.cluster_user }
    
    before { project.close }
    
    it 'should close project' do
      project.should be_closed
    end
    
    it 'should close accounts' do
      project.accounts.all?(&:closed?).should be_true
    end
    
    it 'should close all cluster projects' do
      project.cluster_projects.non_closed.all?(&:closing?).should be_true
    end
    
    it 'should cancel all requests' do
      project.requests.all?(&:closed?).should be_true
    end
  end
end
