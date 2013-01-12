require 'spec_helper'

describe Project do
  let(:project) { create(:project) }
  subject { project }
  
  it 'should have a factory', factory: true do
    should be
  end
  
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
      pending
      
      # let!(:organization) { create(:organization) }
      
      # before do
      #   project.organization = organization
      # end
      
      # it { should have(1).errors_on(:organization) }
    end
  end

  describe '#login' do
    it 'does equal concated prefix and username' do
      subject.login.should == "#{subject.project_prefix}#{subject.username}"
    end
  end
  
  describe '#close', focus: true do
    let!(:project) { create(:project) }
    let!(:account) { create(:active_account, project: project) }
    let!(:cluster_project) { create(:cluster_project, project: project) }
    let!(:cluster_user) { create(:cluster_user, cluster_project: cluster_project) }
    
    before { project.close }
    
    it 'should close project' do
      project.should be_closed
    end
    
    it 'should close accounts' do
      project.accounts(true).all?(&:closed?).should be_true
    end
    
    it 'should close all cluster projects' do
      project.cluster_projects.non_closed.all?(&:closing?).should be_true
    end
    
    it 'should cancel all requests' do
      project.requests.all?(&:closed?).should be_true
    end
  end
end
