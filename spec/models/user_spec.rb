# coding: utf-8
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
  it { should have_many(:owned_projects) }
  it { should have_many(:projects).through(:accounts) }
  it { should have_many(:requests) }
  it { should have_many(:sureties) }
  it { should have_many(:organizations).through(:sureties) }
  
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should ensure_length_of(:password).is_at_least(6) }
  
  it { should allow_mass_assignment_of(:first_name) }
  it { should allow_mass_assignment_of(:last_name) }
  it { should allow_mass_assignment_of(:middle_name) }
  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:remember_me) }
  it { should allow_mass_assignment_of(:new_organization) }
  
  describe '#all_requests' do
    let!(:user) { create(:user_with_projects) }
    let!(:request) { create(:request, project: user.projects.first) }
    
    subject { user.all_requests }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [request] }
  end
  
  describe '#full_name' do
    let(:user) { create(:user, first_name: 'Bruce', last_name: 'Wayne') }
    subject { user.full_name }
    
    it { should == 'Bruce Wayne' }
  end
end
