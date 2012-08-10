FactoryGirl.define do
  factory :ticket_field do
    sequence(:name) { |n| "Field #{n}" }
  end
end
