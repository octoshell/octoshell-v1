require 'spec_helper'

describe Credential do
  let(:credential) { create(:credential) }
  subject { credential }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:public_key) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:public_key).scoped_to(:user_id) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:public_key) }
  it { should allow_mass_assignment_of(:public_key_file) }
  
  describe '#create' do
    let(:credential) { build(:credential, user: create(:sured_user)) }
    
    context 'with posible to activation accesses' do
      before do
        create(:active_account, user: credential.user)
        create(:cluster)
        credential.save
      end
      
      it 'should try activate accesses', focus: true do
        credential.should have(1).accesses
        credential.accesses.all?(&:activing?).should be_true
      end
    end
    
    context 'with impossible to activation accesses' do
      before do
        create(:account, user: credential.user)
        create(:cluster)
        credential.save
      end
      
      it 'should not try to activate accesses' do
        credential.should have(1).accesses
        credential.accesses.all?(&:closed?).should be_true
      end
    end
  end
  
  describe '#close', focus: true do
    let!(:access) { create(:active_access, credential: credential) }
    before { credential.close! }
    
    it 'should close all non closed' do
      access.reload.should be_closing
    end
  end
end
