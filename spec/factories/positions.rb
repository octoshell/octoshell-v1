FactoryGirl.define do
  factory :position do
    membership
    sequence(:name) { |n| "Name 1" }
    value 'Atata'
  end
end
