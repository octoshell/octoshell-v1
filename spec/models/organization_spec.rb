require 'spec_helper'

describe Organization do
  let(:organization) { create(:organization) }
  subject { organization }
  
  it { should have_many(:sureties) }
  it { should have_many(:users).through(:sureties) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:kind) }
  it { should validate_uniqueness_of(:name).scoped_to(:kind) }
  it "should ensure inclusion of kind in #{Organization::KINDS}" do
    Organization::KINDS.each do |kind|
      should allow_value(kind).for(:kind)
    end
  end
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:kind) }
end
