require 'spec_helper'

describe Membership do
  let(:membership) { create(:membership) }
  subject { membership }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should have_many(:positions) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:organization) }
end
