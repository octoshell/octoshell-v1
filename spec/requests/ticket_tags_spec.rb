require 'spec_helper'

describe 'Ticket Tags', js: true do
  describe 'listing' do
    let!(:ticket_tag) { create(:ticket_tag) }
    
    before do
      login create(:admin_user)
      visit ticket_tags_path
    end
    
    it 'should show ticket tag' do
      page.should have_link(ticket_tag.name)
    end
  end
  
  describe 'creating' do
    let!(:ticket_tag) { build(:ticket_tag) }
    
    before do
      login create(:admin_user)
      visit new_ticket_tag_path
      fill_in 'Name', with: ticket_tag.name
      click_button 'Create Ticket tag'
    end
    
    it 'should create ticket template' do
      TicketTag.find_by_name(ticket_tag.name).should be
    end
  end
  
  describe 'updating' do
    let!(:ticket_tag) { create(:ticket_tag) }
    
    before do
      login create(:admin_user)
      visit edit_ticket_tag_path(ticket_tag)
      fill_in 'Name', with: 'Moo'
      click_button 'Update Ticket tag'
    end
    
    it 'should updating ticket tag' do
      ticket_tag.reload.name.should == 'Moo'
    end
  end
  
  describe 'closing' do
    let!(:ticket_tag) { create(:ticket_tag) }
    
    before do
      login create(:admin_user)
      visit ticket_tag_path(ticket_tag)
      click_link 'close'
      confirm_dialog
    end
    
    it 'should close ticket template' do
      ticket_tag.reload.should be_closed
    end
  end
end
