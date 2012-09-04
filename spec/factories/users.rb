FactoryGirl.define do
  factory :inactive_user, class: 'User' do
    first_name 'Richard'
    sequence(:last_name) { |n| "Nixon #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password '123456'
    password_confirmation '123456'
    activation_state 'active'
    
    factory :user do
      after(:create) { |user| user.activate! }
      
      factory :sured_user do
        after(:create) do |user|
          FactoryGirl.create(:active_surety, user: user)
          FactoryGirl.create(:membership, user: user)
        end
      end
      
      factory :closed_user do
        after(:create) do |user|
          user.close!
        end
      end
      
      factory :admin_user do
        admin true
      end
    end
  end
end
