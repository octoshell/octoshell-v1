FactoryGirl.define do
  factory :user do
    first_name 'Richard'
    last_name 'Nixon'
    sequence(:email) { |n| "user_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    activation_state 'active'
    after(:create) do |user, _|
      user.activate!
    end
  end
end
