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
  
  describe '#create' do
    context 'with question with default tags' do
      let(:user) { create(:user) }
      let(:group) { create(:group).tap { |g| g.users << user } }
      let(:tag) { create(:ticket_tag).tap { |t| t.groups << group } }
      let(:question) do
        question = create(:ticket_question)
        question.ticket_tags << tag
        question
      end
      subject { create(:ticket, ticket_question: question) }
      
      its(:active_ticket_tags) { should == [tag] }
      its(:users) { should include(user) }
    end
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
