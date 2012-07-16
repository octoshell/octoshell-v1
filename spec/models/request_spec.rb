require 'spec_helper'

describe Request do
  let(:request) { create(:request) }
  subject { request }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:project) }
  it { should belong_to(:cluster) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:cluster) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:hours) }
  it { should validate_presence_of(:size) }
  it { should validate_numericality_of(:size) }
  
  it { should allow_mass_assignment_of(:hours) }
  it { should allow_mass_assignment_of(:size) }
  it { should allow_mass_assignment_of(:cluster_id) }
  it { should allow_mass_assignment_of(:project_id) }
  
  describe 'validate project on create' do
    let(:request) { build(:request) }
    
    it 'should allow project allowed for user' do
      request.allowed_projects.each do |project|
        request.should allow_value(project).for(:project)
      end
    end
    
    it 'should allow new project' do
      request.should allow_value(Project.new).for(:project)
    end
    
    it 'should deny project denied for user' do
      request.should_not allow_value(create(:project)).for(:project)
    end
  end
  
  describe '#allowed_projects' do
    context 'with user' do
      let(:user) { create(:user_with_projects) }
      let(:request) { build(:request, user: user) }
      
      subject { request.allowed_projects }
      
      it { should == user.projects }
    end
    
    context 'without user' do
      let(:request) { build(:request, user: nil) }
      
      subject { request.allowed_projects }
      
      it { should == [] }
    end
  end
end
