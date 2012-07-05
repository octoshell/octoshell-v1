require 'spec_helper'

describe User do
  let(:user) { create(:user) }
  subject { user }
  
  it 'should have a factory' do
    should be
  end
  
  it { should_not be_external }
  its(:activation_state) { should == 'active' }
  
  it { should have_many(:accounts) }
  it { should have_many(:credentials) }
  
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should ensure_length_of(:password).is_at_least(6) }
  
  describe '#requests' do
    let!(:project) { create(:project) }
    let!(:user) { create(:user) }
    let!(:account) { create(:account, user: user, project: project) }
    let!(:request) { create(:request, project: project) }
    
    subject { user.requests }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [request] }
  end

end
