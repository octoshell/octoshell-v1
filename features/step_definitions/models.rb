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
