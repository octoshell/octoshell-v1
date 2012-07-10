# coding: utf-8
require 'spec_helper'

describe 'Requests' do
  context 'as authorized user' do
    let!(:user) { create(:user) }
    let!(:project) { create(:project, user: user) }
    let!(:cluster) { create(:cluster) }
    
    before do
      login user
      visit new_request_path
      
      within('#new_request') do
        select project.name, from: 'Проект'
        select cluster.name, from: 'Кластер'
        fill_in 'request_hours', with: 10
        submit_button 'commit'
      end
    end
    
    it 'should redirect to dashboard_path' do
      current_path.should == dashboard_path
    end
  end
  
  context 'as non authorized user' do
    before { visit new_request_path }
    
    it { current_path.should == new_session_path }
  end
end
