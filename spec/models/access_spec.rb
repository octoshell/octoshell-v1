require 'spec_helper'

describe Access do
  let(:access) { Fixture.access }
  subject { access }
  
  it { should belong_to(:cluster_user) }
  it { should belong_to(:credential) }
  it { should have_many(:tasks) }
  
  it { should validate_presence_of(:credential) }
  it { should validate_presence_of(:cluster_user) }
  
  describe '#activate' do
    before { access.activate }
    
    it { should be_activing }
    it { access.tasks.add_openkey.pending.count.should == 1 }
  end
  
  describe '#complete_activation' do
    before do
      access.activate
      access.complete_activation
    end
    
    it { should be_active }
  end
    
  describe '#close' do
    before do
      access.activate
      access.complete_activation
      access.close
    end
    
    it { should be_closing }
    it { access.tasks.del_openkey.pending.count.should == 1 }
  end
  
  describe '#complete_closure' do
    before do
      access.activate
      access.complete_activation
      access.close
      access.complete_closure
    end
    
    it { should be_initialized }
  end
    
  describe '#force_close' do
    before do
      access.activate
      access.complete_activation
      access.force_close
    end
    
    it { should be_initialized }
  end
end
