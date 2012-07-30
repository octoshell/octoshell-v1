FactoryGirl.define do
  factory :request do
    cluster
    association :user, factory: :user_with_projects
    hours 1
    size 1
    before(:create) do |request|
      request.project ||= request.user.projects.first
    end
    
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
  end
end
