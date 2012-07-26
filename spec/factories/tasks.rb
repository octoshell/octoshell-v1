FactoryGirl.define do
  factory :task do
    procedure Task::PROCEDURES.first
    association :resource, factory: :request
  end
end
