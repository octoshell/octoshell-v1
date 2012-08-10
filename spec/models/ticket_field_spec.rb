require 'spec_helper'

describe TicketField do
  let(:ticket_field) { create(:ticket_field) }
  subject { ticket_field }
  
  it { should be }
  
  it { should validate_presence_of(:name) }
end
