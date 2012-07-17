FactoryGirl.define do
  factory :task do
    stdin "command"
    association :resource, factory: :request
  end
end
