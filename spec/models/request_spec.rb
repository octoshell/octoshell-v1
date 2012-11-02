require 'spec_helper'

describe Request do
  let(:request) { create(:request) }
  subject { request }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  describe '#task_attributes' do
    before do
      create(:request_property, request: request, name: 'foo', value: 'bar')
    end
    
    subject { request.task_attributes }
    
    it { should be_a_kind_of(Hash) }
    
    it { should == { foo: 'bar', hours: request.hours, size: request.size } }
  end
  
  describe '#close' do
    before do
      request.activate
      request.cluster_project.complete_activation
      request.close
    end
    
    it { should be_closed }
    it { request.cluster_project.should be_pausing }
  end
  
  describe '#activate' do
    before { request.activate }
    
    it { should be_active }
    it { request.cluster_project.should be_activing }
  end
end
