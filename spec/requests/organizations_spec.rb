# coding: utf-8
require 'spec_helper'

describe 'Organizations' do
  context 'as authotized user' do
    let(:organization) { build(:organization) }
    before do
      login
      visit new_organization_path
      within('#new_organization') do
        fill_in 'organization_name', with: organization.name
        select organization.kind, from: 'organization_kind'
        click_button 'Создать'
      end
    end
    
    it 'should show new surety page' do
      current_path.should == new_surety_path
    end
    
    it 'should create new organization' do
      Organization.find_by_name(organization.name).should be
    end
  end
  
  context 'as non authotized user' do
    before { visit new_credential_path }
    
    it 'should show new session page' do
      current_path.should == new_session_path
    end
  end
end
