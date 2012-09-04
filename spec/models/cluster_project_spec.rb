require 'spec_helper'

describe ClusterProject do
  let(:cluster_project) { create(:cluster_project) }
  subject { cluster_project }
  
  it { should be }
  
  it { should belong_to(:request) }
  
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:request) }
  it { should validate_presence_of(:cluster) }
end
