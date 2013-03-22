# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stat do
    session_id 1
    survey_field_id 1
    group_by "MyString"
    weight 1
  end
end
