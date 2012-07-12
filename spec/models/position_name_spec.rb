require 'spec_helper'

describe PositionName do
  let(:position_name) { create(:position_name) }
  subject { position_name }
  
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
