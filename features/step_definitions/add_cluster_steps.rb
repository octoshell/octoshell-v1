Given /^I am signed in as admin$/ do
  admin = FactoryGirl.create(:admin_user)
  visit root_path
  click_link 'Sign in'
  fill_in 'Email', with: admin.email
  fill_in 'Password', with: '123456'
  click_button 'Sign in'
end

Given /^I click Clusters$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I click New Cluster$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I fill new_cluster form with the following:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

When /^I click Create$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the cluster should be created$/ do
  pending # express the regexp above with the code you wish you had
end