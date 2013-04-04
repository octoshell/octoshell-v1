require 'spec_helper'

describe Credential do
  describe '#create' do
    let!(:request) { factory!(:request) }
    let!(:project) { request.project }
    let!(:user) { project.user }
    let!(:account) do
      factory!(:account, project: project, user: user)
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
    let!(:request) { factory!(:request) }
    let!(:project) { request.project }
    let!(:user) { project.user }
    let!(:account) do
      factory!(:account, project: project, user: user)
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
