FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "group_#{n}" }
    system false
  end
end
