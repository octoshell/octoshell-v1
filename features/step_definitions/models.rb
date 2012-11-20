Given /^I have created Public Key$/ do
  step "I navigated to New Public Key"
  step "I filled in Public Key form right"
  step "I click Create"
end

Given /^I have created Membership$/ do
  step "I navigated to New Membership"
  step "I filled in Public Key form right"
  step "I click Create"
end

When /^I filled in Public Key form right$/ do
  step "I fill in Name with MyKey"
  step "I fill in Public key with AAAAA===="
end

When /^I navigated to New Public Key$/ do
  step "I am on root page"
  step "I click Profile"
  step "I click New Public Key"
end

Given /^I havigated to new project$/ do
  step "I am on root page"
  step "I click on Projects"
  step "I click on New Project"
end

When /^I navigated to Membership$/ do
  step "I am on root page"
  step "I click Profile"
  step "I click New Membership"
end
