FactoryGirl.define do
  factory :ticket_question do
    sequence(:question) { |n| "Question #{n}" }
    factory :leaf_ticket_question do
      ticket_question
    end
  end
end
