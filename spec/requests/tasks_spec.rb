require 'spec_helper'

describe 'Tasks' do
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
    
    context 'successing' do
      let!(:task) { create(:task) }
      
      before do
        login create(:admin_user)
        visit task_path(task)
        click_link 'force success'
      end
      
      it 'should success task' do
        within("#task-#{task.id}-status") do
          page.should have_content('successed')
        end
      end
    end
  end
end
