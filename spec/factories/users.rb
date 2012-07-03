FactoryGirl.define do
  factory :inactive_user, class: 'User' do
    first_name 'Richard'
    last_name 'Nixon'
    sequence(:email) { |n| "user_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    activation_state 'active'
    
    factory :user do
      after(:create) { |user| user.activate! }
    end
  end
end
