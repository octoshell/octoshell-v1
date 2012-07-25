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
  
  context 'sured user' do
    let(:user) { create(:sured_user) }
    
    subject { Ability.new(user) }
    
    it_behaves_like 'all users'
    it_behaves_like 'basic user'
    
    it { should be_able_to(:new, :accounts) }
    it { should be_able_to(:create, :accounts) }
  end
  
  context 'confirmed user with membership' do
    let(:user) { create(:sured_user_with_membership) }
    
    subject { Ability.new(user) }
    
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
    
    it { should be_able_to(:access, :admins) }
    
    it { should be_able_to(:show, :accesses) }
    
    it { should be_able_to(:index, :tasks) }
    it { should be_able_to(:show, :tasks) }
    
    it { should be_able_to(:show, :accounts) }
    
    it { should be_able_to(:show, :credentials) }
    it { should be_able_to(:destroy, :credentials) }
    
    it { should be_able_to(:activate, :accounts) }
    it { should be_able_to(:decline, :accounts) }
    it { should be_able_to(:cancel, :accounts) }
    it { should be_able_to(:invite, :accounts) }
    it { should be_able_to(:create, :accounts) }
    it { should be_able_to(:mailer, :accounts) }
    
    it { should be_able_to(:show, :projects) }
    it { should be_able_to(:edit, :projects) }
    it { should be_able_to(:update, :projects) }
    it { should be_able_to(:new, :projects) }
    it { should be_able_to(:create, :projects) }
    
    it { should be_able_to(:show, :dashboard) }
    
    it { should be_able_to(:admin, :users) }
    it { should be_able_to(:edit, :users) }
    it { should be_able_to(:update, :users) }
    
    it { should be_able_to(:index, :requests) }
    it { should be_able_to(:new, :requests) }
    it { should be_able_to(:create, :requests) }
    it { should be_able_to(:show, :requests) }
    it { should be_able_to(:activate, :requests) }
    it { should be_able_to(:decline, :requests) }
    it { should be_able_to(:finish, :requests) }
    
    it { should be_able_to(:index, :sureties) }
    it { should be_able_to(:show, :sureties) }
    it { should be_able_to(:activate, :sureties) }
    it { should be_able_to(:decline, :sureties) }
    it { should be_able_to(:cancel, :sureties) }
    it { should be_able_to(:find, :sureties) }
    
    it { should be_able_to(:index, :organizations) }
    it { should be_able_to(:show, :organizations) }
    it { should be_able_to(:edit, :organizations) }
    it { should be_able_to(:update, :organizations) }
    it { should be_able_to(:merge, :organizations) }
    
    it { should be_able_to(:index, :position_names) }
    it { should be_able_to(:new, :position_names) }
    it { should be_able_to(:create, :position_names) }
    it { should be_able_to(:edit, :position_names) }
    it { should be_able_to(:update, :position_names) }
    it { should be_able_to(:destroy, :position_names) }
    
    it { should be_able_to(:index, :clusters) }
    it { should be_able_to(:new, :clusters) }
    it { should be_able_to(:create, :clusters) }
    it { should be_able_to(:show, :clusters) }
    it { should be_able_to(:edit, :clusters) }
    it { should be_able_to(:update, :clusters) }
    it { should be_able_to(:destroy, :clusters) }
  end
end
