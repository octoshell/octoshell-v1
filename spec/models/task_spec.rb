require 'spec_helper'

describe Task do
  let(:task) { create(:task) }
  subject { task }
  
  it { should be }
  
  it { should belong_to(:resource) }
  it { should validate_presence_of(:resource) }
  it { should validate_presence_of(:procedure) }
  
  describe '#setup' do
    it 'pending'
  end
end
