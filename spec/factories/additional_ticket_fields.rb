FactoryGirl.define do
  factory :ticket_field do
    sequence(:name) { |n| "Field #{n}" }
    
    factory :required_ticket_field do
      required true
    end
  end
end
