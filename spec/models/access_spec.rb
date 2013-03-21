require 'spec_helper'

describe Access do
  let(:access) { create(:access) }
  subject { access }
  
  it "should have a factory", factory: true do
    should be
  end
  
  describe '#activate' do
    before { access.activate }
    
    it { should be_activing }
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
  end
  
  describe '#complete_closure' do
    before do
      access.activate
      access.complete_activation
      access.close
      access.complete_closure
    end
    
    it { should be_closed }
  end
    
  describe '#force_close' do
    before do
      access.activate
      access.complete_activation
      access.force_close
    end
    
    it { should be_closed }
  end
end
