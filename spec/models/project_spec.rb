require 'spec_helper'

describe Project do
  context 'factories', factory: true do
    it { create(:project).should be }
    it { create(:active_project).should be }
    it { create(:blocked_project).should be }
    it { create(:closing_project).should be }
    it { create(:closed_project).should be }
  end
  
  describe '#activate' do
    
  end
  
  describe '#block' do
    it 'blocks all accounts' do
      
    end
  end
  
  describe '#unblock' do
    let(:project) { create(:project) }
    
    it 'unblocks all available accounts' do
      
    end
  end
  
  describe '#closing' do
  end
  
  describe '#closed' do
    
  end
end

