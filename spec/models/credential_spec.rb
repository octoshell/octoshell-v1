require 'spec_helper'

describe Credential do
  let(:credential) { create(:credential) }
  subject { credential }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:public_key) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:public_key).scoped_to(:user_id) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:public_key) }
  it { should allow_mass_assignment_of(:public_key_file) }
  
  
  describe '#close' do
    let(:fixture) { Fixture.new }
    let(:credential) { fixture.credential }
    let(:access) { fixture.access }
    
    before do
      access.activate
      access.complete_activation
      credential.close
    end
    
    it { credential.accesses.all?(&:closing?).should be_true }
  end
end
