# coding: utf-8
require 'spec_helper'

describe 'Admin::Organizations' do
  describe 'listing' do
    let!(:organizations) { 3.times.map { create(:organization) } }
    before do
      login create(:admin_user)
      visit admin_organizations_path
    end
    
    it 'should show organizations' do
      within('#organizations') do
        organizations.each do |organization|
          page.should have_link(organization.name)
        end
      end
    end
  end
  
  describe 'editing' do
    let!(:organization) { create(:organization) }
    before do
      login create(:admin_user)
      visit edit_admin_organization_path(organization)
      fill_in 'organization_name', with: 'Umbrella'
      click_button 'Сохранить'
    end
    
    it 'should show organization page' do
      current_path.should == admin_organization_path(organization)
    end
    
    it 'should update organization' do
      page.should have_content('Umbrella')
    end
  end
end