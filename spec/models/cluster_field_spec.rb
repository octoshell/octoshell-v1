require 'spec_helper'

describe ClusterField do
  let(:cluster_field) { create(:cluster_field) }
  subject { cluster_field }
  
  it { should belong_to(:cluster) }
  it { should validate_presence_of(:cluster) }
end
