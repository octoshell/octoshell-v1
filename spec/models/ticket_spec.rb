require 'spec_helper'

describe Ticket do
  let(:ticket) { create(:ticket) }
  subject { ticket }
  
  it { should be }
  
  it { should be_active }
  
  it 'should create ticket tag relations on create' do
    ticket_tag = create(:ticket_tag)
    ticket = build(:ticket)
    ticket.should have(:no).ticket_tag_relations
    ticket.save
    ticket.should have(1).ticket_tag_relations
  end
  
  describe '#answer' do
    %w(active answered resolved).each do |state|
      context state do
        let(:ticket) { create(:"#{state}_ticket") }
      
        before { ticket.answer! }
      
        it{ should be_answered }
      end
    end
  end
  
  describe '#reply' do
    %w(active answered).each do |state|
      context state do
        let(:ticket) { create(:"#{state}_ticket") }
    
        before { ticket.reply! }
    
        it { should be_active }
      end
    end
  end
  
  describe '#resolve' do
    %w(active answered).each do |state|
      context state do
        let(:ticket) { create(:"#{state}_ticket") }
      
        before { ticket.resolve! }
      
        it { should be_resolved }
      end
    end
  end
  
  describe '#close' do
    %w(active answered resolved).each do |state|
      context state do
        let(:ticket) { create(:"#{state}_ticket") }
      
        before { ticket.close! }
      
        it { should be_closed }
      end
    end
  end
end
