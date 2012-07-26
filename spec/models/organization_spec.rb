require 'spec_helper'

describe Organization do
  let(:organization) { create(:organization) }
  subject { organization }
  
  it { should have_many(:sureties) }
  it { should have_many(:users).through(:sureties) }
  it { should have_many(:memberships) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:kind) }
  it { should validate_uniqueness_of(:name).scoped_to(:kind) }
  it "should ensure inclusion of kind in #{Organization::KINDS}" do
    Organization::KINDS.each do |kind|
      should allow_value(kind).for(:kind)
    end
  end
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:kind) }
  
  describe '#merge' do
    let!(:duplication) { create(:organization) }
    let!(:membership) { create(:membership, organization: duplication) }
    let!(:surety) { create(:surety, organization: duplication) }
    
    before { organization.merge(duplication) }
    
    it 'should move organizations sureties' do
      organization.should have(1).sureties
      organization.sureties.first.user.should == surety.user
    end
    
    it 'should move organizations memberships' do
      organization.should have(1).memberships
      organization.memberships.first.user.should == membership.user
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
