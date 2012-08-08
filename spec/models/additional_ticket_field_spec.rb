require 'spec_helper'

describe AdditionalTicketField do
  let(:additional_ticket_field) { create(:additional_ticket_field) }
  subject { additional_ticket_field }
  
  it { should be }
  
  it { should belong_to(:ticket_question) }
  
  it { should validate_presence_of(:name) }
  
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:hint) }
  it { should allow_mass_assignment_of(:required) }
end
