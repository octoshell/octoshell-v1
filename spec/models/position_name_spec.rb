require 'spec_helper'

describe PositionName do
  let(:position_name) { create(:position_name) }
  subject { position_name }
  
  it 'should have a factory', factory: true do
    should be
  end
end
