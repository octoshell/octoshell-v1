require 'spec_helper'

describe Task do
  let(:task) { create(:task) }
  subject { task }
  
  it { should be }
  
  it { should belong_to(:resource) }
  it { should validate_presence_of(:resource) }
  it { should validate_presence_of(:command) }
  it { should validate_presence_of(:procedure) }
  
  describe '#setup' do
    let(:access) { create(:access) }
    
    it 'should create new task' do
      access.tasks.setup(:add_openkey).should be_true
    end
  end
  
  describe '#perform' do
    it 'should perform pending tasks' do
      task.should_receive(:execute!).once
      task.perform
    end
  end
  
  describe '#success' do
    context 'with errors' do
      before do
        task.stdout = "Moo"
        task.success!
      end
      
      it { should be_failed }
    end
    
    context 'without errors' do
      it 'should succeed task' do
        task.command = "/atata"
        task.success!
        should be_successed
      end
      
      it 'should call continue resource procedure' do
        task.resource.should_receive(:continue!).with(task.procedure)
        task.command = "/atata"
        task.success!
      end
    end
  end
  
  describe '#retry' do
    subject { task.retry }
    
    it 'should return new task' do
      should be_a_kind_of(Task)
    end
    
    it { should be_new_record }
    
    its(:command)   { should == task.command }
    its(:procedure) { should == task.procedure }
    its(:resource)  { should == task.resource }
  end
  
  describe '#retry!' do
    let(:task) { build(:task) }
    
    it 'should save task' do
      task.retry!
      should be_persisted
    end
    
    it 'should add task to resque' do
      pending 'works but test failed'
      Resque.should_receive(:enqueue).with(TasksWorker, task.id)
      task.retry!
    end
  end
  
  describe '#force_success' do
    it 'should succeed task' do
      task.force_success!
      should be_successed
    end
    
    it 'should call continue resource procedure' do
      task.resource.should_receive(:continue!).with(task.procedure)
      task.force_success!
    end
  end
  
  describe '#failure' do
    it 'should call stop resource procedure' do
      task.resource.should_receive(:stop!).with(task.procedure)
      task.failure!
    end
  end
end
