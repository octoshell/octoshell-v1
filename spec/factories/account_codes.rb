# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account_code do
    code "MyString"
    project_id 1
    email "MyString"
  end
end
