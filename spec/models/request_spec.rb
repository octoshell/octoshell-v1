require 'spec_helper'

describe Request do
  let(:request) { create(:request) }
  subject { request }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:project) }
  it { should belong_to(:cluster) }
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:cluster) }
  it { should validate_presence_of(:hours) }
  
  it { should allow_mass_assignment_of(:hours) }
  it { should allow_mass_assignment_of(:cluster_id) }
end
