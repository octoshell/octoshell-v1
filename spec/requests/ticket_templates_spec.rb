require 'spec_helper'

describe 'Ticket Templates', js: true do
  describe 'listing' do
    let!(:ticket_template) { create(:ticket_template) }
    
    before do
      login create(:admin_user)
      visit ticket_templates_path
    end
    
    it 'should show ticket template' do
      page.should have_link(ticket_template.subject)
    end
  end
  
  describe 'creating' do
    let!(:ticket_template) { build(:ticket_template) }
    
    before do
      login create(:admin_user)
      visit new_ticket_template_path
      fill_in 'Subject', with: ticket_template.subject
      click_button 'Create Ticket template'
    end
    
    it 'should create ticket template' do
      TicketTemplate.find_by_subject(ticket_template.subject).should be
    end
  end
  
  describe 'updating' do
    let!(:ticket_template) { create(:ticket_template) }
    
    before do
      login create(:admin_user)
      visit edit_ticket_template_path(ticket_template)
      fill_in 'Subject', with: 'Moo'
      click_button 'Update Ticket template'
    end
    
    it 'should updating ticket template' do
      ticket_template.reload.subject.should == 'Moo'
    end
  end
  
  describe 'closing' do
    let!(:ticket_template) { create(:ticket_template) }
    
    before do
      login create(:admin_user)
      visit ticket_template_path(ticket_template)
      click_link 'close'
      confirm_dialog
      sleep 0.5
    end
    
    it 'should close ticket template' do
      ticket_template.reload.should be_closed
    end
  end
end
