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
        surety.boss_full_name = 'Mr. Burns'
        surety.boss_position = 'CEO'
        surety.surety_members.build do |sm|
          sm.email = project.user.email
        end
        surety.surety_members.build do |sm|
          sm.email = user.email
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
end

