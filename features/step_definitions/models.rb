Given /^there is a project "(.*)"$/ do |name|
  @project = FactoryGirl.create(:project, name: name)
end

Given /^there is a cluster "(.*)"$/ do |name|
  @cluster = FactoryGirl.create(:cluster, name: name)
end

Given /^there is an Ability "(.*)" "(.*)"$/ do |action, subject|
  raw_definitions = Ability.raw_definitions.dup
  Ability.stub(:raw_definitions) do
    raw_definitions.merge(
      subject => [action]
    )
  end
  Ability.redefine!
end

Given /^there is a Group "(.*)"$/ do |name|
  @group = FactoryGirl.create(:group, name: name)
end

Given /^there is a pending request for project "(.*)" on "(.*)"$/ do |project_name, cluster_name|
  project = Project.find_by_name! project_name
  cluster = Cluster.find_by_name! cluster_name
  @request = FactoryGirl.create(:pending_request, project_id: project.id, cluster_id: cluster.id)
end

Given /^the request should be "(.*)"$/ do |state|
  @request.reload.state.should == state
end

Given /^I have created Public Key$/ do
  step 'I navigated to New Public Key'
  step 'I fill in "Name" with "MyKey"'
  step 'I fill in ".js-credential-public-key" with "====="'
  step 'I click on "Create"'
end

Given /^I have created Membership$/ do
  step 'I navigated to New Membership'
  step 'I select "OctoCorp" from "Organization"'
  step 'I click on "Create"'
end

When /^I navigated to New Public Key$/ do
  step 'I am on root page'
  step 'I click on "Profile"'
  step 'I click on "New Public Key"'
end

Given /^I havigated to new project$/ do
  step 'I am on root page'
  step 'I click on "Projects"'
  step 'I click on "New Project"'
end

When /^I navigated to New Membership$/ do
  step 'I am on root page'
  step 'I click on "Profile"'
  step 'I click on "New Membership"'
end

Then /^project prefix with name "(.*)" should be exists$/ do |prefix|
  ProjectPrefix.where(name: prefix).should be_exists
end

Then /^project prefix with name "(.*)" should not be exists$/ do |prefix|
  ProjectPrefix.where(name: prefix).should_not be_exists
end

Then /^Group "(\w+)" should have abilities to "(\w+)" "(\w+)"$/ do |group_name, action, subject|
  group = Group.find_by_name! group_name
  ability = group.abilities.find_by_action_and_subject! action, subject
  group.abilities.should include(ability)
end
