# coding: utf-8
require 'spec_helper'

describe 'Sureties' do
  context 'as authotized user' do
    let!(:org) { create(:organization) }
    let(:surety) { build(:surety, organization: org) }
    before do
      login
      visit new_surety_path
      within('#new_surety') do
        select surety.organization.name, from: 'surety_organization_id'
        click_button 'Создать'
      end
    end
    
    it 'should show profile page' do
      current_path.should == profile_path
    end
  end
  
  context 'as non authotized user' do
    before { visit new_credential_path }
    
    it 'should show new session page' do
      current_path.should == new_session_path
    end
  end
end
