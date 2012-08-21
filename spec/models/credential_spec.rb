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
  
  describe '#grant_accesses' do
    let!(:credential) { create(:generic_credential, user: create(:sured_user)) }
    let!(:project)    { create(:project, user: credential.user) }
    let!(:request)    { create(:active_request, user: credential.user, project: project) }
    
    before { credential.grant_accesses }
    
    it 'should create an access for requests' do
      credential.user.should have(1).accesses
    end
  end
  
  describe '#close' do
    let!(:credential) { create(:generic_credential, user: create(:sured_user)) }
    let!(:project)    { create(:project, user: credential.user) }
    let!(:request)    { create(:active_request, user: credential.user, project: project) }
    
    before do
      credential.grant_accesses
      credential.close
    end
    
    it 'should create an access for requests' do
      credential.user.should have(1).accesses
    end
  end
end
