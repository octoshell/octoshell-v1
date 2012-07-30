FactoryGirl.define do
  factory :task do
    procedure Task::PROCEDURES.first
    association :resource, factory: :activing_request
  end
end
