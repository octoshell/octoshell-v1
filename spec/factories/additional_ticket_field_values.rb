FactoryGirl.define do
  factory :additional_ticket_field_value do
    additional_ticket_field
    ticket
    value 'boo'
  end
end
