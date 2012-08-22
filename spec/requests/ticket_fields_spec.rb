require 'spec_helper'

describe 'Ticket Fields', js: true do
  describe 'listing' do
    let!(:ticket_field) { create(:ticket_field) }
    
    before do
      login create(:admin_user)
      visit ticket_fields_path
    end
    
    it 'should show ticket field' do
      page.should have_link(ticket_field.name)
    end
  end
  
  describe 'creating' do
    let!(:ticket_field) { build(:ticket_field) }
    
    before do
      login create(:admin_user)
      visit new_ticket_field_path
      fill_in 'Name', with: ticket_field.name
      fill_in 'Hint', with: ticket_field.hint
      click_button 'Create Ticket field'
    end
    
    it 'should create ticket field' do
      TicketField.find_by_name(ticket_field.name).should be
    end
  end
  
  describe 'updating' do
    let!(:ticket_field) { create(:ticket_field) }
    
    before do
      login create(:admin_user)
      visit edit_ticket_field_path(ticket_field)
      fill_in 'Name', with: 'Moo'
      click_button 'Update Ticket field'
    end
    
    it 'should update ticket' do
      ticket_field.reload.name.should == 'Moo'
    end
  end
  
  describe 'closing' do
    let!(:ticket_field) { create(:ticket_field) }
    
    before do
      login create(:admin_user)
      visit ticket_field_path(ticket_field)
      click_link 'close'
      confirm_dialog
      sleep 0.5
    end
    
    it 'should close ticket' do
      ticket_field.reload.should be_closed
    end
  end
end
