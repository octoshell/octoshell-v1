Then /^cluster (.*) should be created$/ do |name|
  Cluster.where(name: name).should be_exists
end

Then /^public key (.*) should be created$/ do |name|
  @current_user.credentials.where(name: name).should be_exists
end

Then /^History Item (.*) should be created$/ do |kind|
  @current_user.history_items.where(kind: kind).should be_exists
end

Given /^There is an organization (.*)$/ do |name|
  FactoryGirl.create(:organization, name: name)
end

Given /^There is a direction of science (.*)$/ do |name|
  FactoryGirl.create(:direction_of_science, name: name)
end

Given /^There is a critical technology (.*)$/ do |name|
  FactoryGirl.create(:critical_technology, name: name)
end

Given /^There is a membership for (.*) for current user$/ do |name|
  org = Organization.find_by_name!(name)
  FactoryGirl.create(:membership, user: @current_user, organization: org)
end
