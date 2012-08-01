FactoryGirl.define do
  factory :reply do
    user
    ticket
    message 'Message ...'
  end
end
