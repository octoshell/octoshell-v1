FactoryGirl.define do
  factory :cluster_field do
    cluster
    sequence(:name) { |n| "Cluster Field #{n}" }
  end
end
