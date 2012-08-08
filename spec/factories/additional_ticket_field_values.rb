FactoryGirl.define do
  factory :ticket_field_value do
    ticket_field
    ticket
    value 'boo'
  end
end
