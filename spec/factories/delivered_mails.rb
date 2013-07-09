# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :delivered_mail do
    user_id 1
    subject "MyString"
    body "MyText"
  end
end
