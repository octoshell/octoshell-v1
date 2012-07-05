require 'spec_helper'

describe Institute do
  let(:institute) { create(:institute) }
  subject { institute }
  
  it { should have_many(:users) }
  
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:kind) }
  it "should ensure inclusion of kind in #{Institute::KINDS}" do
    Institute::KINDS.each do |kind|
      should allow_value(kind).for(:kind)
    end
  end
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:kind) }
end
