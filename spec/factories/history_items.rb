# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :history_item do
    user_id 1
    data "MyText"
    kind "MyString"
  end
end
