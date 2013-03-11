# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :survey_value, :class => 'Survey::Value' do
    value "MyText"
    survey_field_id 1
    user_id 1
  end
end
