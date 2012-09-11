require 'spec_helper'

describe Task do
  let!(:task) { create(:task) }
  
  subject { task }
  it 'should have a factory', factory: true do
    should be
  end
end
