require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  
  it 'should have a factory' do
    should be
  end
  
  it { should have_many(:accounts) }
  it { should have_many(:credentials) }
  
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
end
