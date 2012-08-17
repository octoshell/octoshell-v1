require 'spec_helper'

describe Organization do
  let(:organization) { create(:organization) }
  subject { organization }
  
  it { should have_many(:sureties) }
  it { should have_many(:projects) }
  it { should have_many(:users).through(:sureties) }
  it { should have_many(:memberships) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:organization_kind) }
  it { should validate_uniqueness_of(:name).scoped_to(:organization_kind_id) }
  
  it 'should create organization only for non closed organization type' do
    organization = build(:organization, organization_kind: create(:closed_organization_kind))
    organization.should have(1).errors_on(:organization_kind_state_name)
  end
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:organization_kind_id) }
  
  describe '#merge' do
    let!(:project) { create(:project) }
    let!(:duplication) { project.organization }
    let!(:membership) { create(:membership, organization: duplication) }
    let!(:surety) { create(:surety, organization: duplication) }
    
    before { organization.merge(duplication) }
    
    it 'should move organizations sureties' do
      organization.should have(1).sureties
      organization.sureties.first.user.should == surety.user
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
    context 'with pending surety' do
      let!(:surety) { create(:surety, organization: organization) }
      
      before { organization.close }

      subject { surety.reload }
      
      it { should be_closed }
      its(:comment) { should == I18n.t('surety.comments.organization_deleted') }
    end
    
    context 'with active surety' do
      let!(:surety) { create(:active_surety, organization: organization) }
      
      before { organization.close }

      subject { surety.reload }
      
      it { should be_closed }
      its(:comment) { should == I18n.t('surety.comments.organization_deleted') }
    end
    
    context 'organization' do
      before { organization.close }
      
      it { should be_closed }
    end
  end
  
  describe 'creating' do
    let!(:admin) { create(:admin_user) }
    let(:organization) { build(:organization) }
    
    it 'should notify admins about it' do
      mailer = mock; mailer.should_receive(:deliver)
      UserMailer.should_receive(:notify_new_organization).
        with(organization).and_return(mailer)
      organization.save
    end
  end
end
