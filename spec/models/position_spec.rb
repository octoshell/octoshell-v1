require 'spec_helper'

describe Position do
  let(:position) { create(:position) }
  subject { position }
  
  it 'should have a factory', factory: true do
    should be
  end
end
