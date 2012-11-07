require 'spec_helper'

describe Organization do
  let(:organization) { create(:organization) }
  subject { organization }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it 'should create organization only for non closed organization type' do
    organization = build(:organization, organization_kind: create(:closed_organization_kind))
    organization.should have(1).errors_on(:organization_kind_state_name)
  end
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:organization_kind_id) }
  
  describe '#merge' do
    let!(:organization) { create(:organization) }
    let!(:project) { create(:project) }
    let!(:duplication) { project.organization }
    let!(:membership) { create(:membership, organization: duplication) }
    
    before do
      organization.coprojects << project
      organization.merge(duplication)
    end
    
    it 'should move organizations memberships' do
      organization.should have(2).memberships # one from project + 1
      organization.memberships.last.user.should == membership.user
    end
    
    it 'should move organizations projects' do
      organization.should have(1).projects
    end
    
    context 'merge with self' do
      let!(:duplication) { organization }
      
      it 'should do nothing' do
        organization.reload.should be
      end
    end
  end
  
  describe '#close' do
    context 'organization' do
      before { organization.close }
      
      it { should be_closed }
    end
    
    it 'should close projects'
    it 'should close memberships'
  end
  
  describe 'creating' do
    let!(:admin) { create(:admin_user) }
    let(:organization) { build(:organization) }
    
    it 'should notify admins about it' do
      mailer = mock; mailer.should_receive(:deliver)
      Mailer.should_receive(:notify_new_organization).
        with(organization).and_return(mailer)
      organization.save
    end
  end
end
