Then /^cluster "(.*)" should be created$/ do |name|
  Cluster.where(name: name).should be_exists
end

Then /^public key "(.*)" should be created$/ do |name|
  @current_user.credentials.where(name: name).should be_exists
end

Then /^History Item "(.*)" should be created$/ do |kind|
  @current_user.history_items.where(kind: kind).should be_exists
end

Then /^membership for organization "(.*)" should be created$/ do |name|
  org = Organization.find_by_name!(name)
  @current_user.memberships.where(organization_id: org.id).should be_exists
end

Then /^project "(.*)" should be created$/ do |name|
  @current_user.owned_projects.where(name: name).should be_exists
end

Given /^There is an organization "(.*)"$/ do |name|
  FactoryGirl.create(:organization, name: name)
end

Given /^There is a direction of science "(.*)"$/ do |name|
  FactoryGirl.create(:direction_of_science, name: name)
end

Given /^There is a critical technology "(.*)"$/ do |name|
  FactoryGirl.create(:critical_technology, name: name)
end

Given /^There is a membership for "(.*)" for current user$/ do |name|
  org = Organization.find_by_name!(name)
  FactoryGirl.create(:membership, user: @current_user, organization: org)
end

Then /^I should get access to project "(.*)"$/ do |name|
  project = Project.find_by_name!(name)
  @current_user.accounts.where(project_id: project.id).first.should be_active
end

And /^I register as "(.*)"$/ do |email|
  visit root_path
  step %(I click on "Sign Up")
  step %(I fill in "Email" with "#{email}")
  step %(I fill in ".js-password" with "123456")
  step %(I fill in ".js-password-confirmation" with "123456")
  step %(I fill in "First name" with "Bruce")
  step %(I fill in "Last name" with "Wayne")
  step %(I fill in "Middle name" with "-")
  step %(I fill in "Phone" with "000")
  step %(I click on ".js-sign-up-form")
  user = User.find_by_email(email)
  visit activate_user_path(token: user.activation_token)
  @current_user = user
end

Then /^user "(.*)" should be exists$/ do |email|
  User.where(email: 'user@octoshell.com').should be_exists
end

When  /^I fill in Code with right secret code$/ do
  code = AccountCode.pending.first.code
  step %(I fill in "Code" with "#{code}")
end
