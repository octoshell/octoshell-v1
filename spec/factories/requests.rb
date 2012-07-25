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
      state 'active'
    end
    
    factory :closed_request do
      state 'closed'
    end
  end
end
