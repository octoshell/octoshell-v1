require 'spec_helper'

describe RequestProperty do
  let(:request_property) { create(:request_property) }
  subject { request_property }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should belong_to(:request) }
  it { should validate_presence_of(:request) }
end
