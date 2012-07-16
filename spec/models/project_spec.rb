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
  
  describe '#active?' do
    let(:user) { project.user }
    
    subject { project.active? }
    
    context 'with active request' do
      let!(:request) { create(:active_request, project: project, user: user) }
      
      it { should be_true }
    end
    
    context 'without active request' do
      let!(:request) { create(:request, project: project, user: user) }
      
      it { should be_false }
    end
  end
end
