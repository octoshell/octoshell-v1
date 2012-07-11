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
  
  context 'admin' do
    let(:user) { create(:admin_user) }
    
    it_behaves_like 'all users'
    it_behaves_like 'basic user'
    
    it { should be_able_to(:access, :admin) }
    
    it { should be_able_to(:dashboard, :'admin/base') }
    
    it { should be_able_to(:show, :'admin/dashboard') }
    
    it { should be_able_to(:show, :'admin/requests') }
    it { should be_able_to(:index, :'admin/requests') }
    it { should be_able_to(:activate, :'admin/requests') }
    it { should be_able_to(:decline, :'admin/requests') }
    it { should be_able_to(:finish, :'admin/requests') }
  end
end
