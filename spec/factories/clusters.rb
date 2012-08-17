FactoryGirl.define do
  factory :cluster do
    name 'Cluster 1'
    host '0.0.0.0'
    
    factory :closed_cluster do
      after(:create) do |cluster|
        cluster.close!
      end
    end
  end
end
