FactoryGirl.define do
  factory :additional_email do
    sequence(:email) { |n| "email_#{n}@example.com" }
    user
  end
end
