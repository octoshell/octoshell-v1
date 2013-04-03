require 'spec_helper'

describe Project do
  context 'factories', factory: true do
    it { create(:project).should be }
    it { create(:closing_project).should be }
    it { create(:closed_project).should be }
  end
  
  describe '#closing' do
    
  end
  
  describe '#closed' do
    
  end
end

