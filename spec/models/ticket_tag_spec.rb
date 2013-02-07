require 'spec_helper'

describe TicketTag do
  let(:ticket_tag) { create(:ticket_tag) }
  subject { ticket_tag }
  
  it { should validate_presence_of(:name) }
  
  it { should have_many(:ticket_tag_relations) }
  it { should have_many(:tickets).through(:ticket_tag_relations) }
  
  it 'should create ticket tag relations on create' do
    ticket = create(:ticket)
    ticket_tag = build(:ticket_tag)
    ticket_tag.should have(:no).ticket_tag_relations
    ticket_tag.save
    ticket_tag.should have(1).ticket_tag_relations
  end
  
  describe '#merge' do
    let!(:first_tag)  { create(:ticket_tag) }
    let!(:second_tag) { create(:ticket_tag) }
    let!(:ticket)     { create(:ticket) }
    
    before do
      first_tag.merge(second_tag)
    end
    
    it 'should destroy second ticket' do
      TicketTag.where(id: second_tag.id).should_not be_exists
    end
    
    it 'should destroy ticket tag relations of second tag' do
      second_tag.should have(0).ticket_tag_relations
    end
    
    it 'should set active ticket tag relation' do
      first_tag.ticket_tag_relations.first.should be_active
    end
  end
  
  describe '#close' do
    context 'system' do
      subject { create(:ticket_tag, system: true) }
      
      it 'should not being closed' do
        subject.close.should be_false
      end
    end
  end
end
