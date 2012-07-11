require "spec_helper"
require "cancan/matchers"

describe Ability do
  context 'non authorized user' do
    subject { Ability.new(nil) }
    
    it_behaves_like 'all users'
  end
  
  context 'authorized user' do
    let(:user) { create(:user) }
    
    subject { Ability.new(user) }
    
    it_behaves_like 'all users'
    it_behaves_like 'basic user'
  end
  
  context 'confirmed user' do
    let(:user) { create(:sured_user) }
    
    subject { Ability.new(user) }
    
    it_behaves_like 'all users'
    it_behaves_like 'basic user'
    
    it { should be_able_to(:new, :requests) }
    it { should be_able_to(:create, :requests) }
    
    it { should be_able_to(:new, :projects) }
    it { should be_able_to(:create, :projects) }
  end
end
