require 'spec_helper'

describe 'Tasks', js: true do
  context 'as admin user' do
    context 'listing' do
      let!(:tasks) { 3.times.map { create(:task) } }
      
      before do
        login create(:admin_user)
        visit tasks_path
      end
      
      it 'should show tasks' do
        tasks.each do |task|
          page.should have_css("#task-#{task.id}")
        end
      end
    end
    
    context 'call callbacks' do
      let!(:task) { create(:task) }
      
      before do
        login create(:admin_user)
        visit task_path(task)
        click_link I18n.t('call_callbacks')
        task.reload
      end
      
      subject { task }
      
      its(:callbacks_performed) { should be_true } 
    end
  end
end
