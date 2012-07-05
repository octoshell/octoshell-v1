FactoryGirl.define do
  factory :request do
    project
    cluster
    user
    hours 1
  end
end
