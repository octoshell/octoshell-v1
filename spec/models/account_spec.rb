require 'spec_helper'

describe Account do
  let(:account) { create(:account) }
  subject { account }
  
  it 'should have a factory' do
    should be
  end
  
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_uniqueness_of(:project_id).scoped_to(:user_id) }
  
  it { should allow_mass_assignment_of(:project_id) }
end
