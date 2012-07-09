require 'spec_helper'

describe Confirmation do
  let(:confirmation) { create(:confirmation) }
  subject { confirmation }
  
  it { should belong_to(:user) }
  it { should belong_to(:institute) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:institute) }
end
