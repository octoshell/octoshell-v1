require 'spec_helper'

describe Reply do
  let(:reply) { create(:reply) }
  
  subject { reply }
  
  it { should be }
  
  it { should belong_to(:ticket) }
  it { should belong_to(:user) }
  
  it { should validate_presence_of(:ticket) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:message) }
  
  it { should allow_mass_assignment_of(:message) }
  it { should allow_mass_assignment_of(:ticket_id) }
  it { should allow_mass_assignment_of(:attachment) }
  
  describe 'creating' do
    context 'as admin' do
      let(:reply) { build(:reply, user: create(:admin_user)) }
      
      it 'should mark ticket answered' do
        reply.save
        reply.ticket.should be_answered
      end
      
      it 'should send email about new answer' do
        mailer = mock; mailer.should_receive(:deliver)
        UserMailer.should_receive(:new_ticket_answer).with(reply.ticket).and_return(mailer)
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
