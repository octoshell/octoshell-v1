Given /^I am signed in as admin$/ do
  admin = FactoryGirl.create(:admin_user)
  visit root_path
  within('.navbar') do
    click_on 'Sign in'
  end
  within('#new_user') do
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: '123456'
    click_on 'Sign in'
  end
end

Given /^I click (.*)$/ do |name|
  click_on name
end

When /^I fill (.*) with (.*)$/ do |field, value|
  fill_in field, with: value
end

Then /^the cluster (.*) should be created$/ do |name|
  Cluster.find_by_name(name).should be_true
end
