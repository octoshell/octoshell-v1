Given /^I have created Public Key (.*)$/ do |name|
  step "I am on root page"
  step "I click Profile"
  step "I click New Public Key"
  step "I fill in Name with #{name}"
  step "I fill in Public key with AAAAA===="
  step "I click Create"
end
