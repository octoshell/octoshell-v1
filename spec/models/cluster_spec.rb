require 'spec_helper'

describe Cluster do
  let(:cluster) { create(:cluster) }
  subject { cluster }
  
  it 'should have a factory' do
    should be
  end
  
  it { should have_many(:requests) }
  
  it { should validate_presence_of(:name) }
  
  it { should allow_mass_assignment_of(:name) }
end
