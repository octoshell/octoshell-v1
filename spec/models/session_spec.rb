require 'spec_helper'

describe Session do
  let(:session) { create(:session) }
  subject { session }
  
  describe '.create' do
    it 'creates personal survey' do
      session.personal_survey.should be
    end
    
    it 'creates projects survey' do
      session.projects_survey.should be
    end
    
    it 'creates counters survey' do
      session.counters_survey.should be
    end
  end
end
