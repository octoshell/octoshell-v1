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
end
