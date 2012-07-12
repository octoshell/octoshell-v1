require 'set'

shared_examples 'all users' do
  it { should be_able_to(:dashboard, :application) }
  
  it { should be_able_to(:new, :sessions) }
  it { should be_able_to(:create, :sessions) }
  it { should be_able_to(:destroy, :sessions) }
  
  it { should be_able_to(:new, :passwords) }
  it { should be_able_to(:create, :passwords) }
  it { should be_able_to(:confirmation, :passwords) }
  it { should be_able_to(:change, :passwords) }
  
  it { should be_able_to(:new, :users) }
  it { should be_able_to(:create, :users) }
  it { should be_able_to(:activate, :users) }
  it { should be_able_to(:confirmation, :users) }
end

shared_examples 'basic user' do
  it { should be_able_to(:show, :profiles) }
  it { should be_able_to(:edit, :profiles) }
  it { should be_able_to(:update, :profiles) }
  
  it { should be_able_to(:show, :dashboards) }
  
  it { should be_able_to(:new, :organizations) }
  it { should be_able_to(:create, :organizations) }
  
  it { should be_able_to(:new, :sureties) }
  it { should be_able_to(:create, :sureties) }
  it { should be_able_to(:show, :sureties) }
  
  it { should be_able_to(:new, :memberships) }
  it { should be_able_to(:create, :memberships) }
  it { should be_able_to(:edit, :memberships) }
  it { should be_able_to(:update, :memberships) }
  
  it { should be_able_to(:new, :credentials) }
  it { should be_able_to(:create, :credentials) }
  it { should be_able_to(:destroy, :credentials) }
end
