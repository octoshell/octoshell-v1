require 'spec_helper'

describe Request do
  context 'factories', factory: true do
    it { create(:request).should be }
    it { create(:active_request).should be }
    it { create(:declined_request).should be }
    it { create(:closed_request).should be }
    it { create(:blocked_request).should be }
  end
  
  describe 'events' do
    subject(:request)    { factory!(:request) }
    let!(:project)       { request.project }
    let!(:surety)        { factory!(:surety, project: project) }
    let!(:surety_member) { factory!(:surety_member, surety: surety) }
    let!(:account)       { factory!(:account, project: project, user: project.user) }
    
    describe '#activate' do
      before do
        request.activate!
        account.reload
      end
    
      it 'sets status to active' do
        should be_active
      end
    
      it 'sets related accounts cluster state to active' do
        account.should be_active
      end
    
      it 'requests maintain' do
        request.maintain_requested_at.should be
      end
    end
  
    describe '#block' do
      before do
        request.activate!
        request.block!
        account.reload
      end
    
      it 'sets status to blocked' do
        should be_blocked
      end
    
      it 'sets related accounts cluster state to blocked' do
        account.should be_blocked
      end
    
      it 'requests maintain' do
        request.maintain_requested_at.should be
      end
    end
  
    describe '#unblock' do
      before do
        request.activate!
        request.block!
        request.unblock!
        account.reload
      end
      
      it 'sets status to active' do
        should be_active
      end
      
      it 'sets related accounts cluster state to active' do
        account.should be_active
      end
      
      it 'requests maintain' do
        request.maintain_requested_at.should be
      end
    end
  
    describe '#close' do
      before do
        request.activate!
        request.block!
        request.close!
        account.reload
      end
      
      it 'sets status to closed' do
        should be_closed
      end
      
      it 'sets related accounts cluster state to blocked' do
        account.should be_blocked
      end
      
      it 'requests maintain' do
        request.maintain_requested_at.should be
      end
    end
  end
end
