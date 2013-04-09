require 'spec_helper'

describe Credential do
  describe '#create' do
    let!(:user) { create(:sured_user) }
    let!(:project) { create(:project, user: user) }
    let!(:request) { factory!(:request, project: project) }
    
    before do
      request.activate!
      request.complete_maintain!
      factory!(:credential, user: user)
      request.reload
    end
    
    it 'requests maintain for all non-closed requests' do
      request.maintain_requested_at.should be
    end
  end
  
  describe '#close' do
    let!(:user) { create(:sured_user) }
    let!(:project) { create(:project, user: user) }
    let!(:request) { factory!(:request, project: project) }
    
    before do
      request.activate!
      c = factory!(:credential, user: user)
      request.complete_maintain!
      c.close!
      request.reload
    end
    
    it 'requests maintain for all non-closed requests' do
      request.maintain_requested_at.should be
    end
  end
end
