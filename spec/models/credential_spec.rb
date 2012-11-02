require 'spec_helper'

describe Credential do
  let(:credential) { create(:credential) }
  subject { credential }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  describe '#create', focus: true do
    let!(:request)      { create(:active_request) }
    let!(:credential)   { build(:credential, user: request.user) }
    
    context 'with posible to activation accesses' do
      before do
        credential.save
      end
      
      it 'should try activate accesses', focus: true do
        credential.should have(1).accesses
        credential.accesses.joins(:cluster_user).
          where(cluster_users: { state: 'active' }).
          all?(&:activing?).should be_true
      end
    end
    
    context 'with impossible to activation accesses' do
      before do
        request.project.accounts.each do |a|
          a.cancel!
          a.cluster_users(true).each &:complete_closure
        end
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
