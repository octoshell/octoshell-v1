FactoryGirl.define do
  factory :task do
    command "command"
    association :resource, factory: :request
  end
end
