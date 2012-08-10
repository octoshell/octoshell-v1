require 'spec_helper'

describe 'Ticket Questions', js: true do
  describe 'listing' do
    let!(:ticket_question) { create(:ticket_question) }
    
    before do
      login create(:admin_user)
      visit ticket_questions_path
    end
    
    it 'should show ticket question' do
      page.should have_link(ticket_question.question)
    end
  end
  
  describe 'creating' do
    let!(:ticket_question) { build(:ticket_question) }
    
    before do
      login create(:admin_user)
      visit new_ticket_question_path
      fill_in 'Question', with: ticket_question.question
      click_button 'Create Ticket question'
    end
    
    it 'should create ticket question' do
      TicketQuestion.find_by_question(ticket_question.question).should be
    end
  end
  
  describe 'updating' do
    let!(:ticket_question) { create(:ticket_question) }
    
    before do
      login create(:admin_user)
      visit edit_ticket_question_path(ticket_question)
      fill_in 'Question', with: 'Moo'
      click_button 'Update Ticket question'
    end
    
    it 'should updating ticket question' do
      ticket_question.reload.question.should == 'Moo'
    end
  end
  
  describe 'closing' do
    let!(:ticket_question) { create(:ticket_question) }
    
    before do
      login create(:admin_user)
      visit ticket_question_path(ticket_question)
      click_link 'close'
      confirm_dialog
    end
    
    it 'should close ticket question' do
      ticket_question.reload.should be_closed
    end
  end
end
