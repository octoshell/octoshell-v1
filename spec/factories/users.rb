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
      
      factory :user_with_projects do
        after(:create) do |user|
          FactoryGirl.create(:project, user: user)
          FactoryGirl.create(:account, user: user)
        end
      end
    end
  end
end
