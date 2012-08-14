require 'spec_helper'

describe TicketTagRelation do
  let(:ticket_tag_relation) { create(:ticket_tag_relation) }
  subject { ticket_tag_relation }
  
  it { should validate_presence_of(:ticket) }
  it { should validate_presence_of(:ticket_tag) }
  
  it { should belong_to(:ticket) }
  it { should belong_to(:ticket_tag) }
end
