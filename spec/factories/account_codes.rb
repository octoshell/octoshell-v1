FactoryGirl.define do
  factory :account_code do
    code SecureRandom.hex
    project
    surety_member
    email "email@example.com"
  end
end
