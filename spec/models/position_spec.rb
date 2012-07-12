require 'spec_helper'

describe Position do
  let(:position) { create(:position) }
  subject { position }
  
  it { should belong_to(:membership) }
  
  it { should validate_presence_of(:membership) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_uniqueness_of(:name).scoped_to(:membership_id) }
end
