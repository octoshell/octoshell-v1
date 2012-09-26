FactoryGirl.define do
  factory :account_code do
    code SecureRandom.hex
    project
    email "email@example.com"
  end
end
