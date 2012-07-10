require 'spec_helper'

describe Surety do
  let(:surety) { create(:surety) }
  subject { surety }
  
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:organization) }
  
  it { should allow_mass_assignment_of(:organization_id) }
end
