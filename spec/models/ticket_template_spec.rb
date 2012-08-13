require 'spec_helper'

describe TicketTemplate do
  let(:ticket_template) { create(:ticket_template) }
  subject { ticket_template }
  
  it { should be }
  
  it { should validate_presence_of(:subject) }
end
