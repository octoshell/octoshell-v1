FactoryGirl.define do
  factory :additional_ticket_field do
    ticket_question
    sequence(:name) { |n| "Field #{n}" }
    
    factory :required_additional_ticket_field do
      required true
    end
  end
end
