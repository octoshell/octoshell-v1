require 'spec_helper'

describe Task do
  let(:task) { create(:task) }
  subject { task }
  
  it { should be }
  
  it { should belong_to(:resource) }
  it { should have_many(:tasks) }
  it { should validate_presence_of(:resource) }
  it { should validate_presence_of(:command) }
  it { should validate_presence_of(:procedure) }
  
  describe '#setup' do
    let(:access) { create(:cluster_user) }
    
    it 'should create new task' do
      access.tasks.setup(:add_user).should be_true
    end
  end
  
  describe '#perform' do
    it 'should perform pending tasks' do
      task.should_receive(:execute!).once
      task.perform
    end
  end
    
  describe '#perform_callbacks' do
    it 'should succeed task' do
      task.perform_callbacks!
      should be_callbacks_performed
    end
    
    it 'should call continue resource procedure' do
      task.resource.should_receive(:continue!).with(task.procedure, task)
      task.perform_callbacks!
    end
  end
end
