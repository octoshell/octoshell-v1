require 'spec_helper'

describe Project do
  let(:project) { create(:project) }
  subject { project }
  
  it 'should have a factory' do
    should be
  end
end
