Given /^I have created Public Key (.*)$/ do |name|
  step "I navigated to New Public Key"
  step "I filled in Public Key form"
  step "I click Create"
end

When /^I filled in Public Key form$/ do
  step "I fill in Name with MyKey"
  step "I fill in Public key with AAAAA===="
end

When /^I navigated to New Public Key$/ do
  step "I am on root page"
  step "I click Profile"
  step "I click New Public Key"
end
