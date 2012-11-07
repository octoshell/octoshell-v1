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
  
  it 'should create additional email' do
    user.additional_emails.pluck(:email).should include(user.email)
  end
  
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
    
  describe '#revalidate!' do
    context 'potentially sured user' do
      let!(:user) { create(:user) }
      
      before do
        s = create(:active_surety)
        create(:surety_member, surety: s, user: user)
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
    let!(:user) do
      create(:surety_member, user: create(:user_with_membership)).user
    end
    
    before do
      user.sure!
    end
    
    it 'should activate owned accounts' do
      conditions = { project_id: user.owned_project_ids }
      user.accounts.where(conditions).all?(&:active?).should be_true
    end
  end
  
  describe '#unsure' do
    let!(:user) do
      create(:surety_member, user: create(:user_with_membership)).user
    end
    
    before { user.sure!; user.unsure! }
    
    it 'should close all accounts' do
      user.accounts.all?(&:closed?).should be_true
    end
  end
end
