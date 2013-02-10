require 'spec_helper'

describe Task do
  let!(:task) { create(:task) }
  
  subject { task }
  it 'should have a factory', factory: true do
    should be
  end
  
  describe '#create_failure_ticket!' do
    before { subject.create_failure_ticket! }
    
    it 'creates a ticket' do
      subject.should have(1).tickets
    end
  end
end
