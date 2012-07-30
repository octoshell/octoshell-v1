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
      
      context 'add_user' do
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
        
        it 'should activate request' do
          task.resource.should be_active
        end
      end
      
      context 'block_user' do
        let(:task) { create(:block_user_task) }
        
        before do
          login create(:admin_user)
          visit task_path(:task)
          click_link 'force successed'
        end
        
        it 'should success task' do
          within("#task-#{task.id}-status") do
            page.should have_content('successed')
          end
        end
        
        it 'should avtivate access' do
          task.resource.should be_closed
        end
      end
      
      context 'unblock_user' do
        let(:task) { create(:unblock_user_task) }
        
        before do
          login create(:admin_user)
          visit task_path(:task)
          click_link 'force successed'
        end
        
        it 'should success task' do
          within("#task-#{task.id}-status") do
            page.should have_content('successed')
          end
        end
        
        it 'should activate access' do
          task.resource.should be_active
        end
      end
      
      context 'del_user' do
        let(:task) { create(:del_user_task) }
        
        before do
          login create(:admin_user)
          visit task_path(:task)
          click_link 'force successed'
        end
        
        it 'should success task' do
          within("#task-#{task.id}-status") do
            page.should have_content('successed')
          end
        end
        
        it 'should activate access' do
          task.resource.should be_closed
        end
      end
      
      context 'add_openkey' do
        let(:task) { create(:add_openkey_task) }
        
        before do
          login create(:admin_user)
          visit task_path(:task)
          click_link 'force successed'
        end
        
        it 'should success task' do
          within("#task-#{task.id}-status") do
            page.should have_content('successed')
          end
        end
        
        it 'should avtivate access' do
          task.resource.should be_active
        end
      end
    end
  end
end
