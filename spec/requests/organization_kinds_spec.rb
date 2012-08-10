require 'spec_helper'

describe 'Organization Kinds', js: true do
  describe 'listing' do
    let!(:organization_kind) { create(:organization_kind) }
    
    before do
      login create(:admin_user)
      visit organization_kinds_path
    end
    
    it 'should show organization kind' do
      page.should have_link(organization_kind.name)
    end
  end
  
  describe 'creating' do
    let!(:organization_kind) { build(:organization_kind) }
    
    before do
      login create(:admin_user)
      visit new_organization_kind_path
      fill_in 'Name', with: organization_kind.name
      click_button 'Create Organization kind'
    end
    
    it 'should create new organization kind' do
      OrganizationKind.find_by_name(organization_kind.name).should be
    end
  end
  
  describe 'updating' do
    let!(:organization_kind) { create(:organization_kind) }
    
    before do
      login create(:admin_user)
      visit edit_organization_kind_path(organization_kind)
      fill_in 'Name', with: 'Moo'
      click_button 'Update Organization kind'
    end
    
    it 'should update organization kind' do
      organization_kind.reload.name.should == 'Moo'
    end
  end
  
  describe 'closing' do
    let!(:organization_kind) { create(:organization_kind) }
    
    before do
      login create(:admin_user)
      visit organization_kind_path(organization_kind)
      click_link 'close'
      confirm_dialog
    end
    
    it 'should close organization kind' do
      organization_kind.reload.should be_closed
    end
  end
end
