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
  visit new_user_path
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

Then /^there is a Project Prefix "(.*)"$/ do |prefix|
  FactoryGirl.create(:project_prefix, name: prefix)
end

Then /^I should see "(.*)" Project Prefix$/ do |prefix|
  page.should have_content("edu-")
end



Given /^I have a project$/ do
  @project = FactoryGirl.create(:project, user: @current_user)
end

When /I followed to new request page for the project/ do
  visit root_path
  click_on 'Projects'
  click_on @project.name
  within '.link-actions' do
    click_on 'New Request'
  end
end

When /I fill in the request form/ do
  step %(I fill in "Gpu hours" with "1")
  step %(I fill in "Cpu hours" with "1")
  step %(I fill in "Size" with "1")
end

Given /I have an active request for the project/ do
  FactoryGirl.create(:active_request, project_id: @project.id)
end

Given /I navigated to the admin surety/ do
  visit root_path
  click_on 'Sureties'
  within ".js-surety-#{@surety.id}" do
    click_on 'Open'
  end
end

Given /I navigated to the surety/ do
  visit root_path
  step %(debug)
  find('.js-menu-projects').click
  step %(debug)
  click_on @surety.project.name
  step %(debug)
  within ".js-surety-#{@surety.id}" do
    click_on 'Open'
  end
end

Given /I have a pending surety/ do
  project = FactoryGirl.create(:project, user: @current_user)
  @surety = FactoryGirl.create(:surety, project: project)
  FactoryGirl.create(:surety_member, surety: @surety, user: @current_user)
end

Given /There is a pending surety/ do
  @surety = FactoryGirl.create(:surety)  
end

Given /I navigated to Invite to the Project/ do
  visit root_path
  click_on 'Projects'
  within ".js-project-#{@project.id}" do
    click_on 'Invite'
  end
end

And /I wait for a while/ do
  sleep 1
end

Given /^There is a sured user "(.*?)"$/ do |name|
  first, last = name.split(' ')
  FactoryGirl.create(:sured_user, first_name: first, last_name: last)
end

When /^I choose "(.*?)" in select2 box$/ do |name|
  within 'div.select2-container' do
    find('.select2-choice > span').click
    sleep 0.5
  end

  within '.select2-drop' do
    find('.select2-input').set(name)
    sleep 0.5
    find('.select2-result-label', text: name).click
  end
end