require 'spec_helper'

describe Reply do
  let(:reply) { create(:reply) }
  
  subject { reply }
  
  it 'should have a factory', factory: true do
    should be
  end
  
  describe 'creating' do
    context 'as admin' do
      let(:reply) { build(:reply, user: create(:admin_user)) }
      
      it 'should mark ticket answered' do
        reply.save
        reply.ticket.should be_answered
      end
      
      it 'should send email about new answer' do
        mailer = mock; mailer.should_receive(:deliver)
        Mailer.should_receive(:new_ticket_answer).with(reply.ticket).and_return(mailer)
        reply.save
      end
    end
    
    context 'as user' do
      let(:reply) { build(:reply, ticket: create(:answered_ticket)) }
      
      it 'should mark ticket active' do
        reply.save
        reply.ticket.should be_active
      end
    end
  end
end
