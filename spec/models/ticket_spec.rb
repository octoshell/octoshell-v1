require 'spec_helper'

describe Ticket do
  let(:ticket) { create(:ticket) }
  subject { ticket }
  
  it { should be }
  
  it { should have_many(:replies) }
  it { should have_many(:ticket_tag_relations) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:cluster) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:message) }
  
  it { should allow_mass_assignment_of(:subject) }
  it { should allow_mass_assignment_of(:message) }
  it { should allow_mass_assignment_of(:url) }
  it { should allow_mass_assignment_of(:project_id) }
  it { should allow_mass_assignment_of(:cluster_id) }
  
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
