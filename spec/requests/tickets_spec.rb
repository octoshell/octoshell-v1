require 'spec_helper'

describe 'Tickets', js: true do
  describe 'listing' do
    context 'as admin' do
      let!(:user) { create(:admin_user) }
      let!(:ticket) { create(:ticket, user: user) }
      
      before do
        login user
        visit tickets_path
      end
      
      it 'should show ticket' do
        page.should have_link(ticket.subject)
      end
    end
    
    context 'as user' do
      let!(:user) { create(:user) }
      let!(:ticket) { create(:ticket, user: user) }
      
      before do
        login user
        visit tickets_path
      end
      
      it 'should show ticket' do
        page.should have_link(ticket.subject)
      end
    end
  end
  
  describe 'replying' do
    context 'as admin' do
      let!(:user) { create(:admin_user) }
      let!(:ticket) { create(:ticket) }
      
      before do
        login user
        visit ticket_path(ticket)
        fill_in 'Message', with: 'Nooob'
        click_button 'Create Reply'
        sleep 0.5
      end
      
      it { ticket.reload.should be_answered }
      it { page.should have_content('Nooob') }
    end
    
    context 'as user' do
      let!(:user) { create(:user) }
      let!(:ticket) { create(:answered_ticket, user: user) }
      
      before do
        login user
        visit ticket_path(ticket)
        fill_in 'Message', with: 'Nope'
        click_button 'Create Reply'
        sleep 0.5
      end
      
      it { ticket.reload.should be_active }
      it { page.should have_content('Nope') }
    end
  end
  
  describe 'resolving' do
    context 'as user' do
      let!(:user) { create(:user) }
      let!(:ticket) { create(:ticket, user: user) }
      
      before do
        login user
        visit ticket_path(ticket)
        click_link 'resolve'
        sleep 0.5
      end
      
      it { ticket.reload.should be_resolved }
    end
  end
  
  describe 'closing' do
    context 'as admin' do
      let!(:user) { create(:admin_user) }
      let!(:ticket) { create(:ticket) }
      
      before do
        login user
        visit ticket_path(ticket)
        click_link 'close'
        sleep 0.5
      end
      
      it { ticket.reload.should be_closed }
    end
  end
end
