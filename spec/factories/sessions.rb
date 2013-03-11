FactoryGirl.define do
  factory :session do
    sequence(:start_at) { |n| Date.today + (n * 5).days }
    sequence(:end_at) { |n| Date.today + (n * 5 + 1).days }
  end
end
