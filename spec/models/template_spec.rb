require 'spec_helper'

describe Template do
  let(:template) { create(:template) }
  subject { template }
  
  it { should be }
  
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:message) }
end
