FactoryGirl.define do
  factory :field do
    name 'Field Name'
    sequence(:code) { "field #{n}" }
    sequence :position, &:to_i
  end
end
