require 'spec_helper'

describe Project do
  context 'factories', factory: true do
    it { factory!(:project).should be }
    it { factory!(:closing_project).should be }
    it { factory!(:closed_project).should be }
  end
  
  describe '#create' do
    let(:project) { build(:project) }
    let(:user) { create(:user) }
    
    before do
      project.sureties.build do |surety|
        surety.organization = project.organization
        surety.boss_full_name = 'Mr. Burns'
        surety.boss_position = 'CEO'
        surety.surety_members.build do |sm|
          sm.user = project.user
        end
        surety.surety_members.build do |sm|
          sm.user = user
        end
      end
      project.save!
    end
    
    it 'creates accounts for all members in surety' do
      project.should have(2).accounts
    end
    
    it "allows owner's account" do
      account = project.accounts.find_by_user_id(project.user_id)
      account.should be_allowed
    end
  end
  
  describe 'events' do
    let!(:request)       { factory!(:request) }
    subject(:project)    { request.project }
    let!(:surety)        { factory!(:surety, project: project) }
    let!(:surety_member) { factory!(:surety_member, surety: surety) }
    let!(:account)       { factory!(:account, project: project, user: project.user) }
    
    describe '#closing' do
      before do
        request.activate!
        project.close!
        request.reload
      end
      
      it 'sets status to closing' do
        should be_closing
      end
      
      it 'blocks all requests' do
        request.should be_blocked
      end
    end
    
    describe '#resurrect' do
      before do
        request.activate!
        project.close!
        project.resurrect!
      end
      
      it 'sets status to closing' do
        should be_active
      end
    end
    
    describe '#erase' do
      before do
        request.activate!
        project.close!
        project.erase!
        request.reload
        account.reload
      end
      
      it 'sets status to closed' do
        should be_closed
      end
      
      it 'closes all requests' do
        request.should be_closed
      end
      
      it 'closes all accounts' do
        account.should be_closed
      end
    end
  end

  describe '#merge' do
    let!(:project) { factory(:project) }
    let!(:old_project) { factory(:project) }
    let!(:surety) { factory(:surety, project: old_project) }
    let!(:request) { factory(:request, project: old_project) }
    
    before { project.merge(old_project) }
    
    it 'merges organization' do
      project.organization.should == old_project.organization
    end
    
    it 'imports accounts' do
      old_project.accounts.with_access_state(:allowed).each do |account|
        ids = project.accounts.with_access_state(:allowed).pluck(:user_id)
        ids.should include(account.user_id)
      end
    end
    
    it 'imports sureties' do
      project.sureties.should include(surety)
    end
    
    it 'imports requests' do
      project.requests.should include(request)
    end
    
    it 'disables old project' do
      old_project.should be_disabled
    end
  end
end

