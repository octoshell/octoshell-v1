# coding: utf-8
require 'spec_helper'

describe 'Position Names', js: true do
  let!(:position_name) { create(:position_name) }
  
  describe 'listing' do
    before do
      login create(:admin_user)
      visit position_names_path
    end
    
    it 'should show position name' do
      page.should have_css("#position-name-#{position_name.id}")
    end
  end
  
  describe 'creating' do
    before do
      login create(:admin_user)
      visit new_position_name_path
      fill_in 'Name', with: 'boo'
      click_button 'Create Position name'
    end
    
    it 'should create position name' do
      PositionName.find_by_name('boo').should be
    end
  end
  
  describe 'updating' do
    before do
      login create(:admin_user)
      visit edit_position_name_path(position_name)
      fill_in 'Name', with: 'boo'
      click_button 'Update Position name'
    end
    
    it 'should update position name' do
      position_name.reload.name.should == 'boo'
    end
  end
  
  describe 'deleting' do
    before do
      login create(:admin_user)
      visit position_names_path
      click_link 'удалить'
      confirm_dialog
    end
    
    it 'should delete position name' do
      PositionName.find_by_name(position_name.name).should_not be
    end
  end
end
