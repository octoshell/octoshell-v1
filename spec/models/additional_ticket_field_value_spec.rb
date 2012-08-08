require 'spec_helper'

describe AdditionalTicketFieldValue do
  let(:additional_ticket_field_value) { create(:additional_ticket_field_value) }
  subject { additional_ticket_field_value }
  
  it { should belong_to(:additional_ticket_field) }
  it { should belong_to(:ticket) }
  
  it { should validate_presence_of(:additional_ticket_field) }
  it { should validate_presence_of(:ticket) }
  
  context 'with required additional ticket field' do
    let(:additional_ticket_field_value) do
      field = create(:required_additional_ticket_field)
      create(:additional_ticket_field_value, additional_ticket_field: field)
    end
    
    it { should validate_presence_of(:value) }
  end
  
  context 'without required additional ticket field' do
    it { should_not validate_presence_of(:value) }
  end
  
  it { should allow_mass_assignment_of(:additional_ticket_field_id) }
  it { should allow_mass_assignment_of(:ticket_id) }
  it { should allow_mass_assignment_of(:value) }
end
