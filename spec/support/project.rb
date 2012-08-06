shared_examples 'project creator' do
  it 'should create new project' do
    user.projects.should include(new_project)
  end

  it 'should create an account' do
    user.accounts.map(&:project).should include(new_project)
  end

  it 'should create a request' do
    new_project.should have(1).requests
  end

  it 'should redirect to dashboard page' do
    current_path.should == project_path(new_project)
  end
end
