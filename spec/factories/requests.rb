FactoryGirl.define do
  factory :request do
    cluster
    association :user, factory: :user_with_projects
    hours 1
    before(:create) do |request|
      request.project = request.user.projects.first
    end
  end
end
