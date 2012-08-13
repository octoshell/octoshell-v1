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
    
    it { should be_able_to(:index,             :tasks) }
    it { should be_able_to(:show,              :tasks) }
    it { should be_able_to(:perform_callbacks, :tasks) }
    it { should be_able_to(:create,            :tasks) }
    it { should be_able_to(:retry,             :tasks) }
    
    it { should be_able_to(:show, :accounts) }
    
    it { should be_able_to(:show, :cluster_users) }
    
    it { should be_able_to(:show,  :credentials) }
    it { should be_able_to(:close, :credentials) }
    
    it { should be_able_to(:activate, :accounts) }
    it { should be_able_to(:decline,  :accounts) }
    it { should be_able_to(:cancel,   :accounts) }
    it { should be_able_to(:invite,   :accounts) }
    it { should be_able_to(:create,   :accounts) }
    it { should be_able_to(:mailer,   :accounts) }
    
    it { should be_able_to(:show,   :projects) }
    it { should be_able_to(:edit,   :projects) }
    it { should be_able_to(:update, :projects) }
    it { should be_able_to(:new,    :projects) }
    it { should be_able_to(:create, :projects) }
    
    it { should be_able_to(:show, :dashboard) }
    
    it { should be_able_to(:admin,  :users) }
    it { should be_able_to(:edit,   :users) }
    it { should be_able_to(:update, :users) }
    
    it { should be_able_to(:index,    :requests) }
    it { should be_able_to(:new,      :requests) }
    it { should be_able_to(:create,   :requests) }
    it { should be_able_to(:show,     :requests) }
    it { should be_able_to(:activate, :requests) }
    it { should be_able_to(:decline,  :requests) }
    it { should be_able_to(:close,    :requests) }
    
    it { should be_able_to(:index,    :sureties) }
    it { should be_able_to(:show,     :sureties) }
    it { should be_able_to(:activate, :sureties) }
    it { should be_able_to(:decline,  :sureties) }
    it { should be_able_to(:close,    :sureties) }
    it { should be_able_to(:find,     :sureties) }
    
    it { should be_able_to(:index,  :organizations) }
    it { should be_able_to(:show,   :organizations) }
    it { should be_able_to(:edit,   :organizations) }
    it { should be_able_to(:update, :organizations) }
    it { should be_able_to(:merge,  :organizations) }
    
    it { should be_able_to(:index,   :position_names) }
    it { should be_able_to(:new,     :position_names) }
    it { should be_able_to(:create,  :position_names) }
    it { should be_able_to(:edit,    :position_names) }
    it { should be_able_to(:update,  :position_names) }
    it { should be_able_to(:destroy, :position_names) }
    
    it { should be_able_to(:index,   :clusters) }
    it { should be_able_to(:new,     :clusters) }
    it { should be_able_to(:create,  :clusters) }
    it { should be_able_to(:show,    :clusters) }
    it { should be_able_to(:edit,    :clusters) }
    it { should be_able_to(:update,  :clusters) }
    it { should be_able_to(:close, :clusters) }
    
    it { should be_able_to(:index,  :ticket_questions) }
    it { should be_able_to(:show,   :ticket_questions) }
    it { should be_able_to(:new,    :ticket_questions) }
    it { should be_able_to(:create, :ticket_questions) }
    it { should be_able_to(:edit,   :ticket_questions) }
    it { should be_able_to(:update, :ticket_questions) }
    it { should be_able_to(:close,  :ticket_questions) }
    
    it { should be_able_to(:index,  :ticket_fields) }
    it { should be_able_to(:show,   :ticket_fields) }
    it { should be_able_to(:new,    :ticket_fields) }
    it { should be_able_to(:create, :ticket_fields) }
    it { should be_able_to(:edit,   :ticket_fields) }
    it { should be_able_to(:update, :ticket_fields) }
    it { should be_able_to(:close,  :ticket_fields) }
    
    it { should be_able_to(:index,  :organization_kinds) }
    it { should be_able_to(:show,   :organization_kinds) }
    it { should be_able_to(:new,    :organization_kinds) }
    it { should be_able_to(:create, :organization_kinds) }
    it { should be_able_to(:edit,   :organization_kinds) }
    it { should be_able_to(:update, :organization_kinds) }
    it { should be_able_to(:close,  :organization_kinds) }
    
    it { should be_able_to(:index,  :ticket_templates) }
    it { should be_able_to(:show,   :ticket_templates) }
    it { should be_able_to(:new,    :ticket_templates) }
    it { should be_able_to(:create, :ticket_templates) }
    it { should be_able_to(:edit,   :ticket_templates) }
    it { should be_able_to(:update, :ticket_templates) }
    it { should be_able_to(:close,  :ticket_templates) }
    
    it { should be_able_to(:index, :versions) }
    it { should be_able_to(:show,  :versions) }
  end
end
