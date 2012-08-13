FactoryGirl.define do
  factory :ticket_template do
    sequence(:subject) { |n| "subject #{n}" }
    message 'tratata'
  end
end
