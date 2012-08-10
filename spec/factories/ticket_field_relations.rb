FactoryGirl.define do
  factory :ticket_field_relation do
    ticket_question
    ticket_field
    factory :required_ticket_field_relation do
      required true
    end
  end
end
