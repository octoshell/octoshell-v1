require 'spec_helper'

describe Project do
  context 'factories', factory: true do
    it { factory!(:project).should be }
    it { factory!(:closing_project).should be }
    it { factory!(:closed_project).should be }
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

