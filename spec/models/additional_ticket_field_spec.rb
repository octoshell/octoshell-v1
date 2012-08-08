require 'spec_helper'

describe AdditionalTicketField do
  let(:additional_ticket_field) { create(:additional_ticket_field) }
  subject { additional_ticket_field }
  
  it { should be }
  
  it { should validate_presence_of(:name) }
end
