require 'spec_helper'

describe Ticket do
  let(:ticket) { create(:ticket) }
  subject { ticket }
  
  it { should be }
  
  it { should have_many(:replies) }
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:message) }
  
  it { should allow_mass_assignment_of(:subject) }
  it { should allow_mass_assignment_of(:message) }
  it { should allow_mass_assignment_of(:url) }
  
  it { should be_active }
  
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
