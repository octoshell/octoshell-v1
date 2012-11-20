Then /^the cluster (.*) should be created$/ do |name|
  Cluster.where(name: name).should be_exists
end

Then /^the public key (.*) should be created$/ do |name|
  @current_user.credentials.where(name: name).should be_exists
end

Then /^the History Item (.*) should be created$/ do |kind|
  @current_user.history_items.where(kind: kind).should be_exists
end
