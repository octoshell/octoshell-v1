require 'spec_helper'

describe TicketFieldValue do
  let(:ticket_field_value) { create(:ticket_field_value) }
  subject { ticket_field_value }
  
  context 'with required additional ticket field' do
    let(:ticket_field_value) do
      field = create(:required_ticket_field_relation)
      create(:ticket_field_value, ticket_field_relation: field)
    end
    
    it { should validate_presence_of(:value) }
  end
  
  context 'without required additional ticket field' do
    it { should_not validate_presence_of(:value) }
  end
  
  it { should allow_mass_assignment_of(:ticket_field_relation_id) }
  it { should allow_mass_assignment_of(:value) }
end
