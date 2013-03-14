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
  
  describe '.start' do
    let!(:manager) { create(:active_project).user }
    let!(:sured) { create(:sured_user) }
    
    before { session.start! }
    
    context 'manager' do
      subject { manager.user_surveys.map &:survey }
      
      it { should include(session.projects_survey) }
      it { should include(session.counters_survey) }
    end
    
    context 'sured' do
      subject { sured.user_surveys.map &:survey }
      
      it { should include(session.personal_survey) }
    end
  end
end
