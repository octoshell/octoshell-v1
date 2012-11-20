Given /^I am signed in as (.*)$/ do |user|
  user = FactoryGirl.create(:"#{user}_user")
  visit root_path
  within('.navbar') do
    click_on 'Sign in'
  end
  within('#new_user') do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    click_on 'Sign in'
  end
end

Given /^I click (.*)$/ do |name|
  click_on name
end

When /^I fill in (.*) with (.*)$/ do |field, value|
  fill_in field, with: value
end
