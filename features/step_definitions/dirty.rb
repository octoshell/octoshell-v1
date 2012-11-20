Then /^the cluster (.*) should be created$/ do |name|
  Cluster.where(name: name).should be_exists
end

Then /^the public key (.*) should be created$/ do |name|
  Credential.where(name: name).should be_exists
end
