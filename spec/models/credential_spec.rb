require 'spec_helper'

describe Credential do
  let(:credential) { create(:credential) }
  subject { credential }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:public_key) }
  it { should validate_uniqueness_of(:public_key).scoped_to(:user_id) }
  
  it { should allow_mass_assignment_of(:public_key) }
end
