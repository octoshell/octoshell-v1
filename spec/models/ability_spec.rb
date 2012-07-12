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
    
    subject { Ability.new(user) }
    
    it_behaves_like 'all users'
    it_behaves_like 'basic user'
    
    it { should be_able_to(:access, :admin) }
    
    it { should be_able_to(:dashboard, :'admin/base') }
    
    it { should be_able_to(:show, :'admin/dashboards') }
    
    it { should be_able_to(:show, :'admin/requests') }
    it { should be_able_to(:index, :'admin/requests') }
    it { should be_able_to(:activate, :'admin/requests') }
    it { should be_able_to(:decline, :'admin/requests') }
    it { should be_able_to(:finish, :'admin/requests') }
    
    it { should be_able_to(:show, :'admin/sureties') }
    it { should be_able_to(:index, :'admin/sureties') }
    it { should be_able_to(:activate, :'admin/sureties') }
    it { should be_able_to(:decline, :'admin/sureties') }
    it { should be_able_to(:cancel, :'admin/sureties') }
    
    it { should be_able_to(:index, :'admin/organizations') }
    it { should be_able_to(:show, :'admin/organizations') }
    it { should be_able_to(:edit, :'admin/organizations') }
    it { should be_able_to(:update, :'admin/organizations') }
  end
end
