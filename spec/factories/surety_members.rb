FactoryGirl.define do
  factory :surety_member do
    surety
    email { |s| (s.user ||= create(:user)).email }
    full_name { |s| (s.user ||= create(:user)).full_name }
  end
end
