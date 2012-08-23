FactoryGirl.define do
  factory :cluster do
    sequence(:name) { |n| "Cluster #{n}" }
    host '0.0.0.0'
    
    factory :closed_cluster do
      after(:create) do |cluster|
        cluster.close!
      end
    end
  end
end
