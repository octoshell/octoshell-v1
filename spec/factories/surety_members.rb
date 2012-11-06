FactoryGirl.define do
  factory :surety_member do
    surety
    email { create(:user).email }
    full_name { create(:user).full_name }
  end
end
