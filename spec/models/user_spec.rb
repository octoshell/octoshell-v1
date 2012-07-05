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
  it { should have_many(:projects) }
  it { should have_many(:requests) }
  it { should belong_to(:institute) }
  
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:institute) }
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
  it { should allow_mass_assignment_of(:institute_id) }
  it { should allow_mass_assignment_of(:new_institute) }
  
  describe '#all_requests' do
    let!(:project) { create(:project) }
    let!(:user) { create(:user) }
    let!(:account) { create(:account, user: user, project: project) }
    let!(:request) { create(:request, project: project) }
    
    subject { user.all_requests }
    
    it { should be_a_kind_of(ActiveRecord::Relation) }
    it { should == [request] }
  end
  
  describe '#new_institute=' do
    before { user.new_institute = { name: 'Acme', kind: 'ВУС' } }
    subject { user }
    
    it 'should build new institute' do
      user.institute.name.should == 'Acme'
      user.institute.kind.should == 'ВУС'
    end
    
    it 'should build new institute' do
      user.new_institute.name.should == 'Acme'
      user.new_institute.kind.should == 'ВУС'
    end
  end
end
