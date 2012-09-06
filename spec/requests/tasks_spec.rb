# coding: utf-8
require 'spec_helper'

describe 'Tasks', js: true do
  # describe 'listing' do
  #   let!(:tasks) { 3.times.map { create(:task) } }
  #   
  #   before do
  #     login create(:admin_user)
  #     visit tasks_path(search: { state_in: ['pending'] })
  #   end
  #   
  #   it 'should show tasks' do
  #     tasks.each do |task|
  #       page.should have_css("#task-#{task.id}")
  #     end
  #   end
  # end
  # 
  # describe 'call callbacks' do
  #   let!(:task) { create(:task) }
  #   
  #   before do
  #     login create(:admin_user)
  #     visit task_path(task)
  #     click_link I18n.t('call_callbacks')
  #     task.reload
  #   end
  #   
  #   subject { task }
  #   
  #   its(:callbacks_performed) { should be_true } 
  # end
  # 
  # describe 'retry' do
  #   let!(:base_task) { create(:task) }
  #   
  #   before do
  #     login create(:admin_user)
  #     visit task_path(base_task)
  #     click_link 'Повторить задание'
  #     click_button 'Create Task'
  #   end
  #   
  #   it 'should create new task' do
  #     base_task.tasks.count.should == 1
  #   end
  # end
  # 
  # describe 'resolve' do
  #   let!(:task) { create(:failed_task) }
  #   
  #   before do
  #     login create(:admin_user)
  #     visit task_path(task)
  #     click_link 'resolve'
  #   end
  #   
  #   it 'should resolve task' do
  #     task.reload.should be_successed
  #   end
  # end
end
