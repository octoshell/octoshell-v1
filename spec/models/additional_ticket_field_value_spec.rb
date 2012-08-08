require 'spec_helper'

describe TicketFieldValue do
  let(:ticket_field_value) { create(:ticket_field_value) }
  subject { ticket_field_value }
  
  it { should belong_to(:ticket_field) }
  it { should belong_to(:ticket) }
  
  it { should validate_presence_of(:ticket_field) }
  it { should validate_presence_of(:ticket) }
  
  context 'with required additional ticket field' do
    let(:ticket_field_value) do
      field = create(:required_ticket_field)
      create(:ticket_field_value, ticket_field: field)
    end
    
    it { should validate_presence_of(:value) }
  end
  
  context 'without required additional ticket field' do
    it { should_not validate_presence_of(:value) }
  end
  
  it { should allow_mass_assignment_of(:ticket_field_id) }
  it { should allow_mass_assignment_of(:ticket_id) }
  it { should allow_mass_assignment_of(:value) }
end
