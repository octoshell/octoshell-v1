# coding: utf-8
require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should_not be_external }
  its(:activation_state) { should == 'active' }
  
  it { should have_many(:accounts) }
  it { should have_many(:credentials) }
  it { should have_many(:owned_projects) }
  it { should have_many(:projects).through(:accounts) }
  it { should have_many(:requests) }
  it { should have_many(:memberships) }
  it { should have_many(:sureties) }
  it { should have_many(:organizations).through(:sureties) }
  it { should have_many(:tickets) }
  
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should ensure_length_of(:password).is_at_least(6) }
  
  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should allow_mass_assignment_of(:middle_name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }
  it { should allow_mass_assignment_of(:new_organization) }
  
  describe '#full_name' do
    let(:user) { create(:user, first_name: 'Bruce', last_name: 'Wayne') }
    subject { user.full_name }
    
    it { should == 'Bruce Wayne' }
  end
  
  describe '#sured?' do
    context 'basic user' do
      let(:user) { create(:user) }
      
      it { should_not be_sured }
    end
    
    context 'sured user' do
      let(:user) { create(:sured_user) }
      
      it { should be_sured }
    end
  end
  
  describe '#project_steps' do
    def step(name)
      I18n.t("steps.#{name}.html")
    end
    
    subject { user.project_steps }
    
    context 'user with surety' do
      let(:user) { create(:sured_user) }
      
      it { should_not include(step :surety) }
    end
    
    context 'user without surety' do
      let(:user) { create(:user) }
      
      it { should include(step :surety) }
    end
  end
    
  describe '#revalidate!' do
    context 'potentially sured user' do
      let!(:user) { create(:user) }
      
      before do
        create(:active_surety, user: user)
        create(:membership, user: user)
        user.revalidate!
      end
      
      it { should be_sured }
    end
    
    context 'potentially unsured user' do
      let!(:user) { create(:sured_user) }
      
      before do
        user.sureties.delete_all
        user.memberships.delete_all
        user.revalidate!
      end
      
      it { should be_active }
    end
  end
  
  describe '#close' do
    let!(:user) { create(:sured_user) }
    let!(:credential) { create(:credential, user: user) }
    let!(:ticket) { create(:ticket, user: user) }
    
    before { user.close }
    
    it 'should close all credentials' do
      user.credentials.all?(&:closed?).should be_true
    end
    
    it 'should close all projects' do
      user.projects.all?(&:closed?).should be_true
    end
    
    it 'should close all tickets' do
      user.tickets.all?(&:closed?).should be_true
    end
    
    it 'should send last email for user'
    
    it 'should rename users email'
  end
  
  describe '#sure' do
    let(:user) { Fixture.user }
    
    before do
      user.unsure!
      user.sure!
    end
    
    it 'should activate owned accounts' do
      conditions = { project_id: user.owned_project_ids }
      user.accounts.where(conditions).all?(&:active?).should be_true
    end
  end
  
  describe '#unsure' do
    let(:user) { Fixture.user }
    
    before { user.unsure! }
    
    it 'should close all accounts' do
      user.accounts.all?(&:closed?).should be_true
    end
  end
end
