FactoryGirl.define do
  factory :template do
    sequence(:subject) { |n| "subject #{n}" }
    message 'tratata'
  end
end
