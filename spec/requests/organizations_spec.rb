require 'spec_helper'

describe 'Organizations', js: true do
  context 'as authotized user' do
    let!(:organization_kind) { create(:organization_kind) }
    let(:organization) { build(:organization, organization_kind: organization_kind) }
    
    before do
      login
      visit new_organization_path
      within('#new_organization') do
        fill_in 'Name', with: organization.name
        select organization.kind, from: 'Organization kind'
        click_button 'Create Organization'
      end
    end
    
    def new_organization
      Organization.find_by_name(organization.name)
    end
    
    it 'should show new surety page' do
      current_path.should == dashboard_path
    end
    
    it 'should create new organization' do
      new_organization.should be
    end
  end
  
  context 'as non authotized user' do
    before { visit new_credential_path }
    
    it 'should show new session page' do
      current_path.should == new_session_path
    end
  end
end
