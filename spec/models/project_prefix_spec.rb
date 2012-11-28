require 'spec_helper'

describe ProjectPrefix do
  let(:project_prefix) { create(:project_prefix) }
  subject { project_prefix }
  
  it 'does have a factory' do
    subject.should be
  end

  describe '#to_s' do
    it 'does equal name' do
      subject.to_s.should == subject.name
    end
  end
end
