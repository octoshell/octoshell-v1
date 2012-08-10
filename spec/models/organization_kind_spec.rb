require 'spec_helper'

describe OrganizationKind do
  let(:organization_kind) { create(:organization_kind) }
  subject { organization_kind }
  
  it { should be }
  
  it { should validate_presence_of(:name) }
end
