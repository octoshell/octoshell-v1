require 'spec_helper'

describe Access do
  let(:access) { create(:access) }
  subject { access }
  
  it { should belong_to(:cluster_user) }
  it { should belong_to(:credential) }
  it { should have_many(:tasks) }
  
  it { should validate_presence_of(:credential) }
  it { should validate_presence_of(:cluster_user) }
  
  describe '#activate' do
    let(:access) { create(:pending_access) }
    
    before { access.activate }
    
    it { should be_activing }
    it { access.tasks.add_openkey.pending.count.should == 1 }
  end
  
  describe '#complete_activation' do
    let(:access) { create(:activing_access) }
    
    before { access.complete_activation }
    
    it { should be_active }
  end
  
  describe '#failure_activation' do
    let(:access) { create(:activing_access) }
    
    before { access.failure_activation }
    
    it { should be_pending }
  end
  
  describe '#close' do
    let(:access) { create(:active_access) }
    
    before { access.close }
    
    it { should be_closing }
    it { access.tasks.del_openkey.pending.count.should == 1 }
  end
  
  describe '#complete_closure' do
    let(:access) { create(:closing_access) }
    
    before { access.complete_closure }
    
    it { should be_closed }
  end
  
  describe '#failure_closure' do
    let(:access) { create(:closing_access) }
    
    before { access.failure_closure }
    
    it { should be_active }
  end
  
  describe '#force_close' do
    let(:access) { create(:access) }
    
    before { access.force_close }
    
    it { should be_closed }
  end
end
