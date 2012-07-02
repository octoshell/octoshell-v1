require 'spec_helper'

describe Field do
  let(:field) { create(:field) }
  subject { field }
  
  it 'should have a factory' do
    should be
  end
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_presence_of(:position) }
  
  it { should allow_mass_assignment_of(:code).as(:admin) }
  it { should allow_mass_assignment_of(:name).as(:admin) }
  it { should allow_mass_assignment_of(:position).as(:admin) }
  
end
