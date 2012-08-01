FactoryGirl.define do
  factory :ticket do
    user
    message 'Sausage'
    subject 'I have a problem...'
    
    factory :active_ticket do
      state 'active'
    end
    
    factory :answered_ticket do
      after(:create) do |ticket|
        ticket.answer!
      end
    end
    
    factory :resolved_ticket do
      after(:create) do |ticket|
        ticket.answer!
        ticket.resolve!
      end
    end
    
    factory :closed_ticket do
      after(:create) do |ticket|
        ticket.answer!
        ticket.resolve!
        ticket.close!
      end
    end
  end
end
