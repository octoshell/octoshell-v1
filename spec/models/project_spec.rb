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
  
  describe '#revalidate!' do
    context 'when announced' do
      subject do
        project = create(:project)
        project.state = 'announced'
        project
      end
      
      context 'and has an active request' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.stub(:has_active_request?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_active }
      end
      
      context 'and has not any requests' do
        it { should be_announced }
      end
      
      context 'and has requests and but no one active' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_blocked }
      end
    end
    
    context 'when active' do
      subject do
        project = create(:project)
        project.state = 'active'
        project
      end
      
      context 'and has an active request' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.stub(:has_active_request?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_active }
      end
      
      context 'and has not any active requests' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_blocked }
      end
    end
    context 'when blocked' do
      subject do
        project = create(:project)
        project.state = 'blocked'
        project
      end
      
      context 'and has an active request' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.stub(:has_active_request?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_active }
      end
      
      context 'and has not any active requests' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_blocked }
      end
    end
    context 'when closed' do
      subject do
        project = create(:project)
        project.state = 'closed'
        project
      end
      
      context 'and has an active request' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.stub(:has_active_request?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_closed }
      end
      
      context 'and has not any active requests' do
        before do
          subject.stub(:has_requests?).and_return(true)
          subject.revalidate!
        end
        
        it { should be_closed }
      end
    end
  end
  
  describe '#notify_about_blocking' do
    subject { create(:project) }
    
    it 'should send emails for all active accounts' do
      mailer = mock; mailer.should_receive(:deliver)
      project.accounts.each do |account|
        Mailer.should_receive(:project_blocked).with(account).and_return(mailer)
      end
      project.notify_about_blocking
    end
  end
end
