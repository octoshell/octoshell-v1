require 'spec_helper'

describe Value do
  let(:value) { create(:value) }
  subject { value }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:model) }
  it { should belong_to(:field) }
  
  it { should validate_presence_of(:model) }
  it { should validate_presence_of(:field) }
  it 'should validate_uniqueness_of model_id scoped to model_type and field_id' do
    existed = create(:value)
    Value.new do |value|
      value.model = existed.model
      value.field = existed.field
    end.should have(1).errors_on(:model_id)
  end
end
