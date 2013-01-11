FactoryGirl.define do
  factory :ability do
    sequence(:action) { |n| "action_#{n}" }
    sequence(:subject) { |n| "subject_#{n}" }
  end
end
