FactoryGirl.define do
  factory :ticket_field_value do
    ticket_field_relation
    ticket
    value 'boo'
  end
end
