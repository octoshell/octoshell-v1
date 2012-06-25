require 'spec_helper'

describe Value do
  let(:value) { create(:value) }
  subject { value }
  
  it 'should have a factory' do
    should be
  end
end
