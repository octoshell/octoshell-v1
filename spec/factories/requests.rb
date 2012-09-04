FactoryGirl.define do
  factory :request do
    hours 1
    size 1
    
    factory :active_request do
      after(:create) do |request|
        request.activate!
      end
    end
    
    factory :closed_request do
      after(:create) do |request|
        request.close!
      end
    end
    
    factory :pending_request do
    end
  end
end
