# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey_field, :class => 'Survey::Field' do
    survey_id 1
    kind "MyString"
    collection "MyText"
    collection_sql "MyText"
    max_values 1
  end
end
